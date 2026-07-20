variable "location" {
  description = "Azure region for all resources."
  type        = string
}

variable "brand" {
  description = "Brand full name used in tags."
  type        = string
}

variable "environment" {
  description = "Environment full name used in tags."
  type        = string
}

variable "project" {
  description = "Project full name used in tags."
  type        = string
}

variable "managed_by" {
  description = "Tool that manages these resources."
  type        = string
  default     = "Terraform"
}

variable "brand_short_name" {
  description = "Brand short name used in resource names."
  type        = string
}

variable "environment_short_name" {
  description = "Environment short name used in resource names."
  type        = string
}

variable "project_short_name" {
  description = "Project short name used in resource names."
  type        = string
}

variable "location_short_name" {
  description = "Location short name used in resource names."
  type        = string
}

variable "app_service_sku_name" {
  description = "App Service plan SKU for this environment."
  type        = string
  default     = "B1"
}

variable "postgres_sku_name" {
  description = "PostgreSQL Flexible Server SKU for this environment."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "db_admin_login" {
  description = "PostgreSQL administrator login."
  type        = string
  default     = "bhraman_admin"
}

variable "db_admin_password" {
  description = "PostgreSQL administrator password. Supplied via TF_VAR_db_admin_password from GitHub secrets; never committed."
  type        = string
  sensitive   = true
}

variable "site_admin_password" {
  description = "Website /admin password. Supplied via TF_VAR_site_admin_password from GitHub secrets; never committed."
  type        = string
  sensitive   = true
}
