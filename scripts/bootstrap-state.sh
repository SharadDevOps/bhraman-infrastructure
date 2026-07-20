#!/usr/bin/env bash
# One-time bootstrap of the Azure Storage backend used for Terraform state.
# Requires: az login with rights to create resource groups and storage accounts.
set -euo pipefail

LOCATION="centralindia"
RESOURCE_GROUP="bhr-tfstate-cin-rg"
STORAGE_ACCOUNT="bhrtfstatecin"
CONTAINER="tfstate"

az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false
az storage container create --name "$CONTAINER" --account-name "$STORAGE_ACCOUNT" --auth-mode login

echo "Terraform state backend ready: $RESOURCE_GROUP / $STORAGE_ACCOUNT / $CONTAINER"
