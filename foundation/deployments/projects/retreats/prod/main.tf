data "azurerm_container_registry" "acr" {
  name                = "acrbhrretcin"
  resource_group_name = "rg-bhr-acr-cin"
}

module "resource_group" {
  source              = "../../../modules/resource-group"
  resource_group_name = local.resource_group_name
  location            = var.location
  tags                = local.tags
}

module "storage_account" {
  source               = "../../../modules/storage-account"
  storage_account_name = local.storage_account_name
  resource_group_name  = module.resource_group.name
  location             = var.location
  container_name       = "retreat-media"
  tags                 = local.tags
}

module "postgres" {
  source              = "../../../modules/postgres-flexible"
  server_name         = "psql-${local.name_suffix}"
  resource_group_name = module.resource_group.name
  location            = var.location
  database_name       = "bhraman"
  admin_login         = var.db_admin_login
  admin_password      = var.db_admin_password
  sku_name            = var.postgres_sku_name
  tags                = local.tags
}

module "app_service" {
  source              = "../../../modules/app-service"
  service_plan_name   = "asp-${local.name_suffix}"
  web_app_name        = "app-${local.name_suffix}"
  resource_group_name = module.resource_group.name
  location            = var.location
  sku_name            = var.app_service_sku_name
  docker_image_name   = "bhraman-retreats:latest"
  docker_registry_url = "https://${data.azurerm_container_registry.acr.login_server}"

  app_settings = {
    DATABASE_URL                 = "postgresql://${var.db_admin_login}:${var.db_admin_password}@${module.postgres.fqdn}:5432/${module.postgres.database_name}?sslmode=require"
    ADMIN_PASSWORD               = var.site_admin_password
    AZURE_STORAGE_ACCOUNT_NAME   = module.storage_account.name
    AZURE_STORAGE_CONTAINER_NAME = module.storage_account.container_name
  }

  tags = local.tags
}

resource "azurerm_role_assignment" "app_blob_contributor" {
  scope                = module.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.app_service.principal_id
}

resource "azurerm_role_assignment" "app_acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.app_service.principal_id
}
