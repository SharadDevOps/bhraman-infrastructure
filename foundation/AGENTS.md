# Terraform Conventions

Rules for AI-assisted and human edits to this repository. Preserve these conventions.

## Layout

- All Terraform lives under `foundation/deployments`.
- Reusable modules: `foundation/deployments/modules/<module>/` with exactly `main.tf`, `variables.tf`, `outputs.tf`. Every input needs a description and type; expose identifiers downstream modules need.
- Environment roots: `foundation/deployments/projects/<project>/<environment>/` with exactly `backend.tf`, `locals.tf`, `main.tf`, `outputs.tf`, `terraform.tfvars`, `variables.tf`.
- Current projects: `retreats` with environments `dev` and `prod`.

## Backend and providers

- State backend: Azure Storage (`bhr-tfstate-cin-rg` / `bhrtfstatecin` / container `tfstate`), key `retreats/<environment>.tfstate`. State locking uses blob leases.
- `required_version = ">= 1.5.0"`; `hashicorp/azurerm` pinned to `~> 3.100`; provider configured with `features {}`.

## Naming and tags

- Resource names use a type prefix followed by `<brand_short>-<project_short>-<environment_short>-<location_short>`:
  resource group `rg-bhr-ret-dev-cin`, App Service plan `asp-...`, web app `app-...`, PostgreSQL `psql-...`, storage `stbhrretdevcin` (no hyphens).
- Tags on every resource: `Brand`, `Environment`, `Project`, `ManagedBy`.

## Secrets

- Authentication uses OIDC federated credentials (`ARM_USE_OIDC`); no client secret exists.
- Never write passwords, client secrets, access keys, or tokens to any file.
- Secret variables (`db_admin_password`, `site_admin_password`) are supplied via `TF_VAR_*` environment variables from GitHub Actions secrets.
- `terraform.tfvars` may contain non-secret values only.
