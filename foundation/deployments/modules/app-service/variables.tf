variable "service_plan_name" {
  description = "Name of the App Service plan."
  type        = string
}

variable "web_app_name" {
  description = "Globally unique name of the Linux Web App."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that hosts the plan and app."
  type        = string
}

variable "location" {
  description = "Azure region for the plan and app."
  type        = string
}

variable "sku_name" {
  description = "App Service plan SKU, for example B1 or S1."
  type        = string
  default     = "B1"
}

variable "node_version" {
  description = "Node.js runtime version for the application stack."
  type        = string
  default     = "20-lts"
}

variable "app_command_line" {
  description = "Startup command for the app."
  type        = string
  default     = "node server.js"
}

variable "always_on" {
  description = "Keep the app loaded at all times."
  type        = bool
  default     = true
}

variable "app_settings" {
  description = "Application settings (environment variables) for the web app."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "tags" {
  description = "Tags applied to the plan and app."
  type        = map(string)
  default     = {}
}
