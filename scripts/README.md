# Scripts

Repeatable, non-secret automation for the Bhraman infrastructure.
See `../docs/deployment-strategy.md` for the full deployment workflow.

Run these once, in order, with `az login` as an Owner:

- `bootstrap-tfstate.ps1 -ClientId <app-id>` — creates the Terraform state
  backend (`bhr-tfstate-cin-rg` / `bhrtfstatecin` / `tfstate`) and grants the
  deployment service principal **Storage Blob Data Contributor** on the state
  account and **Contributor** on the subscription.

- `setup-oidc.ps1 -ClientId <app-id>` — creates the GitHub OIDC federated
  credentials on the service principal (pull_request, main branch, and the
  `dev` / `prod` / `destroy` environments). Idempotent. Add `-UseImmutableIds $true`
  only if login fails with AADSTS700213 in a tenant that issues immutable subjects.

Legacy: `bootstrap-state.ps1` / `bootstrap-state.sh` create only the state
account without role assignments — superseded by `bootstrap-tfstate.ps1`.

Never store credentials, tokens, or access keys in this directory.
