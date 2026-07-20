output "name" {
  description = "Storage account name."
  value       = azurerm_storage_account.this.name
}

output "id" {
  description = "Storage account resource ID."
  value       = azurerm_storage_account.this.id
}

output "primary_blob_endpoint" {
  description = "Primary blob service endpoint."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "container_name" {
  description = "Media container name."
  value       = azurerm_storage_container.media.name
}
