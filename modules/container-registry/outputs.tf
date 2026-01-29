output "container_registry_id" {
  description = "The ID of the Container Registry"
  value       = azurerm_container_registry.this.id
}

output "container_registry_name" {
  description = "The name of the Container Registry"
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "The login server of the Container Registry"
  value       = azurerm_container_registry.this.login_server
}

output "admin_username" {
  description = "The admin username"
  value       = var.admin_enabled ? azurerm_container_registry.this.admin_username : null
}

output "admin_password" {
  description = "The admin password"
  value       = var.admin_enabled ? azurerm_container_registry.this.admin_password : null
  sensitive   = true
}

output "identity_principal_id" {
  description = "The Principal ID associated with the managed identity"
  value       = try(azurerm_container_registry.this.identity[0].principal_id, null)
}

output "identity_tenant_id" {
  description = "The Tenant ID associated with the managed identity"
  value       = try(azurerm_container_registry.this.identity[0].tenant_id, null)
}

output "sku" {
  description = "The SKU of the Container Registry"
  value       = azurerm_container_registry.this.sku
}

output "resource_group_name" {
  description = "The resource group name of the Container Registry"
  value       = azurerm_container_registry.this.resource_group_name
}

output "location" {
  description = "The location of the Container Registry"
  value       = azurerm_container_registry.this.location
}

output "public_network_access_enabled" {
  description = "Whether public network access is enabled"
  value       = azurerm_container_registry.this.public_network_access_enabled
}

output "admin_enabled" {
  description = "Whether admin user is enabled"
  value       = azurerm_container_registry.this.admin_enabled
}

output "zone_redundancy_enabled" {
  description = "Whether zone redundancy is enabled"
  value       = azurerm_container_registry.this.zone_redundancy_enabled
}

output "data_endpoint_enabled" {
  description = "Whether dedicated data endpoints are enabled"
  value       = azurerm_container_registry.this.data_endpoint_enabled
}
