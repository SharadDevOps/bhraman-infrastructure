locals {
  name_suffix         = "${var.brand_short_name}-${var.project_short_name}-${var.environment_short_name}-${var.location_short_name}"
  resource_group_name = "rg-${local.name_suffix}"

  storage_account_name = "st${var.brand_short_name}${var.project_short_name}${var.environment_short_name}${var.location_short_name}"

  tags = {
    Brand       = var.brand
    Environment = var.environment
    Project     = var.project
    ManagedBy   = var.managed_by
  }
}
