output "container_registries" {
  description = "Map of all container registries created (excluding sensitive data)"
  value = {
    for k, cr in azurerm_container_registry.this : k => {
      id                            = cr.id
      name                          = cr.name
      login_server                  = cr.login_server
      resource_group_name           = cr.resource_group_name
      location                      = cr.location
      sku                           = cr.sku
      admin_enabled                 = cr.admin_enabled
      public_network_access_enabled = cr.public_network_access_enabled
      zone_redundancy_enabled       = cr.zone_redundancy_enabled
      data_endpoint_enabled         = cr.data_endpoint_enabled
    }
  }
}

output "container_registry_ids" {
  description = "Map of container registry keys to IDs"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.id }
}

output "container_registry_names" {
  description = "Map of container registry keys to names"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.name }
}

output "login_servers" {
  description = "Map of container registry keys to login servers"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.login_server }
}

output "admin_usernames" {
  description = "Map of container registry keys to admin usernames"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.admin_enabled ? cr.admin_username : null }
}

output "admin_passwords" {
  description = "Map of container registry keys to admin passwords"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.admin_enabled ? cr.admin_password : null }
  sensitive   = true
}

output "identity_principal_ids" {
  description = "Map of container registry keys to identity principal IDs"
  value       = { for k, cr in azurerm_container_registry.this : k => try(cr.identity[0].principal_id, null) }
}

output "identity_tenant_ids" {
  description = "Map of container registry keys to identity tenant IDs"
  value       = { for k, cr in azurerm_container_registry.this : k => try(cr.identity[0].tenant_id, null) }
}

output "skus" {
  description = "Map of container registry keys to SKUs"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.sku }
}

output "resource_group_names" {
  description = "Map of container registry keys to resource group names"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.resource_group_name }
}

output "locations" {
  description = "Map of container registry keys to locations"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.location }
}

output "public_network_access_enabled" {
  description = "Map of container registry keys to public network access enabled status"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.public_network_access_enabled }
}

output "admin_enabled" {
  description = "Map of container registry keys to admin enabled status"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.admin_enabled }
}

output "zone_redundancy_enabled" {
  description = "Map of container registry keys to zone redundancy enabled status"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.zone_redundancy_enabled }
}

output "data_endpoint_enabled" {
  description = "Map of container registry keys to data endpoint enabled status"
  value       = { for k, cr in azurerm_container_registry.this : k => cr.data_endpoint_enabled }
}
