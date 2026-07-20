output "server_name" {
  description = "PostgreSQL server name."
  value       = azurerm_postgresql_flexible_server.this.name
}

output "id" {
  description = "PostgreSQL server resource ID."
  value       = azurerm_postgresql_flexible_server.this.id
}

output "fqdn" {
  description = "Fully qualified domain name of the server."
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_name" {
  description = "Application database name."
  value       = azurerm_postgresql_flexible_server_database.this.name
}
