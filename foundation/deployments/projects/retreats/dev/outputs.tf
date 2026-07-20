output "resource_group_name" {
  description = "Environment resource group."
  value       = module.resource_group.name
}

output "web_app_name" {
  description = "Web app name for pipeline deployments."
  value       = module.app_service.web_app_name
}

output "web_app_hostname" {
  description = "Public hostname of the web app."
  value       = module.app_service.default_hostname
}

output "postgres_fqdn" {
  description = "PostgreSQL server FQDN."
  value       = module.postgres.fqdn
}

output "storage_account_name" {
  description = "Media storage account name."
  value       = module.storage_account.name
}
