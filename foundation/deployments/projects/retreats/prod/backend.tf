terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  backend "azurerm" {
    resource_group_name  = "bhr-tfstate-cin-rg"
    storage_account_name = "bhrtfstatecin"
    container_name       = "tfstate"
    key                  = "retreats/prod.terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}
