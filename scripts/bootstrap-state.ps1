# One-time bootstrap of the Azure Storage backend used for Terraform state.
# Requires: az login with rights to create resource groups and storage accounts.
$ErrorActionPreference = "Stop"

$Location       = "centralindia"
$ResourceGroup  = "bhr-tfstate-cin-rg"
$StorageAccount = "bhrtfstatecin"
$Container      = "tfstate"

az group create --name $ResourceGroup --location $Location
if ($LASTEXITCODE -ne 0) { throw "Failed to create resource group" }

az storage account create `
  --name $StorageAccount `
  --resource-group $ResourceGroup `
  --location $Location `
  --sku Standard_LRS `
  --min-tls-version TLS1_2 `
  --allow-blob-public-access false
if ($LASTEXITCODE -ne 0) { throw "Failed to create storage account" }

az storage container create --name $Container --account-name $StorageAccount --auth-mode login
if ($LASTEXITCODE -ne 0) { throw "Failed to create container" }

Write-Host "Terraform state backend ready: $ResourceGroup / $StorageAccount / $Container"
