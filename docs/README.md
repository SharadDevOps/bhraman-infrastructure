# Bhraman Infrastructure Documentation

## Architecture

Each environment (dev, prod) provisions in Central India:

- Resource group `rg-bhr-ret-<env>-cin`
- Linux App Service plan + web app `app-bhr-ret-<env>-cin` (Node 20, HTTPS-only, system-assigned identity) running the Next.js site
- PostgreSQL Flexible Server `psql-bhr-ret-<env>-cin` (v16) with database `bhraman`
- Storage account `stbhrret<env>cin` with private container `retreat-media`

Terraform state lives in Azure Storage (`bhr-tfstate-cin-rg` / `bhrtfstatecin` / `tfstate`), bootstrapped once via `scripts/bootstrap-state.sh`.

## Required GitHub secrets (repository level)

Values are never stored in this repository.

- `ARM_CLIENT_ID`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` — Entra app registration with Contributor on the subscription.
  Authentication uses OIDC federated credentials (no client secret). The app registration
  needs federated credentials whose subjects cover every context the workflows run in:
  `repo:SharadDevOps/bhraman-infrastructure:pull_request`,
  `repo:SharadDevOps/bhraman-infrastructure:ref:refs/heads/main`,
  and `repo:SharadDevOps/bhraman-infrastructure:environment:<dev|prod|destroy>`.
- `TF_VAR_DB_ADMIN_PASSWORD` — PostgreSQL admin password
- `TF_VAR_SITE_ADMIN_PASSWORD` — website /admin password

App repository (BhramanRetreats) additionally needs, per GitHub environment:

- `AZURE_WEBAPP_PUBLISH_PROFILE` — publish profile of the target web app

## Protected GitHub environments

Create `dev`, `prod`, and `destroy` environments with required reviewers before running apply or destroy workflows.

## Workflows

- `terraform-plan.yml` — plans on pull requests and on manual dispatch
- `terraform-apply.yml` — manual apply for one project/environment, gated by the protected environment
- `terraform-destroy.yml` — manual destroy (`all` or specific), gated by the `destroy` environment
- `pre-checks.yml` — fmt check, TFLint, KICS on PRs and pushes to main

## App cutover checklist (before first deployment)

1. Switch `prisma/schema.prisma` provider from `sqlite` to `postgresql` in the app repository and create a fresh migration.
2. The app currently stores uploads on local disk (`public/uploads`); App Service persists `/home` only. Move uploads to the `retreat-media` blob container (the `AZURE_STORAGE_*` app settings are already wired) when ready.
3. Deploy via the app repository's `deploy-app.yml` workflow using the publish profile.
