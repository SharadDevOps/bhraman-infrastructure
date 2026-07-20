<#
.SYNOPSIS
  Create/update GitHub OIDC federated credentials on the deployment service
  principal so GitHub Actions authenticates to Azure with no client secret.

.DESCRIPTION
  Builds one federated credential per pipeline trigger. Handles both the
  standard (name-only) subject form and the immutable-ID form
  (repo:<ORG>@<ORG_ID>/<REPO>@<REPO_ID>:<trigger>) by reading numeric IDs from
  the GitHub API. Idempotent: updates existing credentials instead of failing.

  Run with `az login`. No secrets stored.

.PARAMETER ClientId
  App/client ID of the deployment service principal.
.PARAMETER Org
  GitHub organization / owner (e.g. SharadDevOps).
.PARAMETER Repo
  Repository name (e.g. bhraman-infrastructure).
.PARAMETER Environments
  GitHub environment names that run apply/destroy (default: dev, prod, destroy).
.PARAMETER UseImmutableIds
  Force immutable-ID subjects. Default $false (name-only). Set $true if Azure
  rejects the login with AADSTS700213 and your tenant issues immutable subjects.
#>
param(
  [Parameter(Mandatory = $true)] [string]$ClientId,
  [string]$Org  = "SharadDevOps",
  [string]$Repo = "bhraman-infrastructure",
  [string[]]$Environments = @("dev", "prod", "destroy"),
  [bool]$UseImmutableIds = $false
)

$ErrorActionPreference = "Stop"
$issuer   = "https://token.actions.githubusercontent.com"
$audience = "api://AzureADTokenExchange"

# Resolve repo prefix (name-only or immutable-ID form)
if ($UseImmutableIds) {
  $orgId  = (Invoke-RestMethod "https://api.github.com/users/$Org").id
  $repoId = (Invoke-RestMethod "https://api.github.com/repos/$Org/$Repo").id
  $repoPrefix = "repo:$Org@$orgId/$Repo@$repoId"
  Write-Host "Using immutable-ID subjects: $repoPrefix"
} else {
  $repoPrefix = "repo:$Org/$Repo"
  Write-Host "Using name subjects: $repoPrefix"
}

# trigger name -> subject suffix
$creds = [ordered]@{
  "gh-pull-request" = "${repoPrefix}:pull_request"
  "gh-main"         = "${repoPrefix}:ref:refs/heads/main"
}
foreach ($env in $Environments) {
  $creds["gh-env-$env"] = "${repoPrefix}:environment:$env"
}

# Existing credential names on the app
$existing = az ad app federated-credential list --id $ClientId --query "[].name" -o tsv

foreach ($name in $creds.Keys) {
  $subject = $creds[$name]
  $params = @{
    name      = $name
    issuer    = $issuer
    subject   = $subject
    audiences = @($audience)
  } | ConvertTo-Json -Compress

  $tmp = New-TemporaryFile
  Set-Content -Path $tmp -Value $params -Encoding utf8

  if ($existing -and ($existing -split "`n") -contains $name) {
    az ad app federated-credential update --id $ClientId --federated-credential-id $name --parameters "@$tmp" | Out-Null
    Write-Host "updated  $name -> $subject"
  } else {
    az ad app federated-credential create --id $ClientId --parameters "@$tmp" | Out-Null
    Write-Host "created  $name -> $subject"
  }
  Remove-Item $tmp -Force
}

Write-Host ""
Write-Host "Federated credentials configured. Verify with:"
Write-Host "  az ad app federated-credential list --id $ClientId -o table"
