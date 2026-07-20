resource "azurerm_service_plan" "this" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                = var.web_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true

  site_config {
    always_on                               = var.always_on
    http2_enabled                           = true
    minimum_tls_version                     = "1.2"
    ftps_state                              = "Disabled"
    container_registry_use_managed_identity = true

    application_stack {
      docker_image_name   = var.docker_image_name
      docker_registry_url = var.docker_registry_url
    }
  }

  app_settings = merge(var.app_settings, {
    WEBSITES_PORT                       = "8080"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  })

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
