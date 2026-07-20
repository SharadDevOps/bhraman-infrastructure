data "azurerm_client_config" "current" {}

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
  server_name         = "${local.name_prefix}-psql"
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
  service_plan_name   = "${local.name_prefix}-asp"
  web_app_name        = "${local.name_prefix}-app"
  resource_group_name = module.resource_group.name
  location            = var.location
  sku_name            = var.app_service_sku_name

  app_settings = {
    DATABASE_URL                        = "postgresql://${var.db_admin_login}:${var.db_admin_password}@${module.postgres.fqdn}:5432/${module.postgres.database_name}?sslmode=require"
    ADMIN_PASSWORD                      = var.site_admin_password
    AZURE_STORAGE_ACCOUNT_NAME          = module.storage_account.name
    AZURE_STORAGE_CONTAINER_NAME        = module.storage_account.container_name
    SCM_DO_BUILD_DURING_DEPLOYMENT      = "false"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
  }

  tags = local.tags
}
