variable "storage_account_name" {
  description = "Globally unique storage account name (3-24 lowercase alphanumeric characters)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that hosts the storage account."
  type        = string
}

variable "location" {
  description = "Azure region for the storage account."
  type        = string
}

variable "container_name" {
  description = "Name of the private blob container for media uploads."
  type        = string
  default     = "retreat-media"
}

variable "account_replication_type" {
  description = "Replication type for the storage account."
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags applied to the storage account."
  type        = map(string)
  default     = {}
}
