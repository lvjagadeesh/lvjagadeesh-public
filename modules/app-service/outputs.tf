output "app_service_id" {
  description = "The ID of the App Service"
  value       = azurerm_linux_web_app.this.id
}

output "app_service_name" {
  description = "The name of the App Service"
  value       = azurerm_linux_web_app.this.name
}

output "default_hostname" {
  description = "The default hostname of the App Service"
  value       = azurerm_linux_web_app.this.default_hostname
}

output "identity_principal_id" {
  description = "The principal ID of the system-assigned identity"
  value       = try(azurerm_linux_web_app.this.identity[0].principal_id, null)
}
