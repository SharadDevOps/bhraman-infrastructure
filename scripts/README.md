# Scripts

Repeatable, non-secret automation for the Bhraman infrastructure.

- `bootstrap-state.sh` — one-time creation of the Azure Storage account that
  holds Terraform state (`bhr-tfstate-cin-rg` / `bhrtfstatecin` / `tfstate`).
  Run it once with `az login` before the first `terraform init`.

Never store credentials, tokens, or access keys in this directory.
