# Resource Group Outputs
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = module.resource_group.resource_group_name
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = module.resource_group.resource_group_id
}

# Virtual Network Outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.virtual_network.vnet_id
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = module.virtual_network.subnet_ids
}

# Storage Account Outputs
output "storage_account_id" {
  description = "ID of the storage account"
  value       = module.storage_account.storage_account_id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage_account.storage_account_name
}

# Key Vault Outputs
output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.key_vault.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

# App Service Plan Outputs
output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = module.app_service_plan.app_service_plan_id
}

# App Service Outputs
output "app_service_id" {
  description = "ID of the App Service"
  value       = module.app_service.app_service_id
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service"
  value       = module.app_service.default_hostname
}

# SQL Server Outputs
output "sql_server_id" {
  description = "ID of the SQL Server"
  value       = module.sql_server.sql_server_id
}

output "sql_server_fqdn" {
  description = "FQDN of the SQL Server"
  value       = module.sql_server.sql_server_fqdn
}

# SQL Database Outputs
output "sql_database_id" {
  description = "ID of the SQL Database"
  value       = module.sql_database.database_id
}

# Container Registry Outputs
output "container_registry_id" {
  description = "ID of the Container Registry"
  value       = module.container_registry.container_registry_id
}

output "container_registry_login_server" {
  description = "Login server of the Container Registry"
  value       = module.container_registry.login_server
}

# AKS Cluster Outputs
output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks_cluster.cluster_id
}

output "aks_cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.aks_cluster.cluster_fqdn
}
