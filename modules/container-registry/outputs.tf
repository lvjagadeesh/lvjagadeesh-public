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
