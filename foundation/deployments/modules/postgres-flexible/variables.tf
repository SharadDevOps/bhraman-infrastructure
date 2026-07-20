variable "server_name" {
  description = "Name of the PostgreSQL Flexible Server."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that hosts the server."
  type        = string
}

variable "location" {
  description = "Azure region for the server."
  type        = string
}

variable "database_name" {
  description = "Application database name."
  type        = string
  default     = "bhraman"
}

variable "admin_login" {
  description = "Administrator login name."
  type        = string
}

variable "admin_password" {
  description = "Administrator password. Supply via TF_VAR environment variable or workspace variable; never commit it."
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "Flexible server SKU, for example B_Standard_B1ms."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  description = "Provisioned storage in MB."
  type        = number
  default     = 32768
}

variable "postgres_version" {
  description = "PostgreSQL major version."
  type        = string
  default     = "16"
}

variable "backup_retention_days" {
  description = "Backup retention in days."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied to the server."
  type        = map(string)
  default     = {}
}
