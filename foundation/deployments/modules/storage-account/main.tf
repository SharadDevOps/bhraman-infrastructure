resource "azurerm_storage_account" "this" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = var.account_replication_type
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = var.allow_public_blobs
  https_traffic_only_enabled      = true
  tags                            = var.tags
}

resource "azurerm_storage_container" "media" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.this.name
  # "blob" = anonymous read of blobs (public image URLs); "private" otherwise.
  container_access_type = var.allow_public_blobs ? "blob" : "private"
}
