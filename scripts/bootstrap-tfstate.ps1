<#
.SYNOPSIS
  One-time bootstrap of the Terraform remote-state backend on Azure Storage,
  plus the role assignments the deployment service principal needs.

.DESCRIPTION
  Creates the state resource group, storage account (StorageV2, TLS1.2, no public
  blob), and blob container. Grants the deployment service principal:
    - Storage Blob Data Contributor on the state storage account (AAD state access)
    - Contributor on the subscription (to build resources)

  Run once with `az login` as an Owner (or Contributor + User Access Administrator).
  No secrets are stored; identifiers are read from the CLI session or passed in.

.PARAMETER ClientId
  App/client ID of the deployment service principal (federated / OIDC).
#>
param(
  [Parameter(Mandatory = $true)]
  [string]$ClientId,

  [string]$Location       = "centralindia",
  [string]$StateRg        = "bhr-tfstate-cin-rg",
  [string]$StateSa        = "bhrtfstatecin",
  [string]$StateContainer = "tfstate"
)

$ErrorActionPreference = "Stop"

$subscriptionId = az account show --query id -o tsv
if ($LASTEXITCODE -ne 0) { throw "Not logged in. Run 'az login' first." }
Write-Host "Subscription: $subscriptionId"

# 1. State resource group
az group create --name $StateRg --location $Location | Out-Null

# 2. State storage account
az storage account create `
  --name $StateSa `
  --resource-group $StateRg `
  --location $Location `
  --sku Standard_LRS `
  --kind StorageV2 `
  --min-tls-version TLS1_2 `
  --allow-blob-public-access false | Out-Null

# 3. State container (AAD auth)
az storage container create --name $StateContainer --account-name $StateSa --auth-mode login | Out-Null

# Resolve the service principal object id from its app/client id
$spObjectId = az ad sp show --id $ClientId --query id -o tsv
if ($LASTEXITCODE -ne 0) { throw "Service principal for app $ClientId not found. Create the app registration / enterprise app first." }

# 4. Storage Blob Data Contributor on the state storage account
$saScope = az storage account show --name $StateSa --resource-group $StateRg --query id -o tsv
az role assignment create `
  --assignee-object-id $spObjectId `
  --assignee-principal-type ServicePrincipal `
  --role "Storage Blob Data Contributor" `
  --scope $saScope | Out-Null

# 5. Contributor on the subscription
az role assignment create `
  --assignee-object-id $spObjectId `
  --assignee-principal-type ServicePrincipal `
  --role "Contributor" `
  --scope "/subscriptions/$subscriptionId" | Out-Null

Write-Host ""
Write-Host "State backend ready: $StateRg / $StateSa / $StateContainer"
Write-Host "Roles granted to SP ${ClientId}: Storage Blob Data Contributor (state SA), Contributor (subscription)."
