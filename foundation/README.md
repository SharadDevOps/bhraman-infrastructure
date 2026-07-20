# Foundation

Terraform configuration for Bhraman Retreats on Azure.

## Structure

- `deployments/modules` — reusable modules: `resource-group`, `app-service`, `postgres-flexible`, `storage-account`.
- `deployments/projects/retreats/dev` and `.../prod` — environment roots. Each environment provisions a resource group, a Linux App Service (Node 20), a PostgreSQL Flexible Server, and a private media storage account.

## Backend

State is stored in Azure Storage (`bhr-tfstate-cin-rg` / `bhrtfstatecin` / `tfstate`) with per-environment keys. Run `../scripts/bootstrap-state.sh` once before the first init.

## Standard commands

Run inside an environment directory (`deployments/projects/retreats/dev` or `prod`):

    terraform init
    terraform fmt -recursive
    terraform validate
    terraform plan
    terraform apply

Secrets are supplied via environment variables, never files:

    export TF_VAR_db_admin_password=...
    export TF_VAR_site_admin_password=...

## Adding a project, module, or environment

- New module: create `deployments/modules/<name>/` with `main.tf`, `variables.tf`, `outputs.tf`.
- New environment: copy an existing environment directory, update `terraform.tfvars` (full/short names, SKUs) and the backend `key`, then update workflow input descriptions.
- New project: create `deployments/projects/<project>/<environment>/` per environment with all six files.
