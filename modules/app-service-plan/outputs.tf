output "app_service_plans" {
  description = "Map of all App Service Plans created"
  value = {
    for k, asp in azurerm_service_plan.this : k => {
      id                           = asp.id
      name                         = asp.name
      location                     = asp.location
      resource_group_name          = asp.resource_group_name
      os_type                      = asp.os_type
      sku_name                     = asp.sku_name
      kind                         = asp.kind
      reserved                     = asp.reserved
      app_service_environment_id   = asp.app_service_environment_id
      maximum_elastic_worker_count = asp.maximum_elastic_worker_count
      worker_count                 = asp.worker_count
      per_site_scaling_enabled     = asp.per_site_scaling_enabled
      zone_balancing_enabled       = asp.zone_balancing_enabled
      tags                         = asp.tags
    }
  }
}

output "app_service_plan_ids" {
  description = "Map of App Service Plan keys to IDs"
  value       = { for k, asp in azurerm_service_plan.this : k => asp.id }
}

output "app_service_plan_names" {
  description = "Map of App Service Plan keys to names"
  value       = { for k, asp in azurerm_service_plan.this : k => asp.name }
}

output "locations" {
  description = "Map of App Service Plan keys to locations"
  value       = { for k, asp in azurerm_service_plan.this : k => asp.location }
}

output "resource_group_names" {
  description = "Map of App Service Plan keys to resource group names"
  value       = { for k, asp in azurerm_service_plan.this : k => asp.resource_group_name }
}

output "os_types" {
  description = "Map of App Service Plan keys to OS types"
  value       = { for k, asp in azurerm_service_plan.this : k => asp.os_type }
}

output "sku_names" {
  description = "Map of App Service Plan keys to SKU names"
  value       = { for k, asp in azurerm_service_plan.this : k => asp.sku_name }
}

output "kinds" {
  description = "Map of App Service Plan keys to kinds"
  value       = { for k, asp in azurerm_service_plan.this : k => asp.kind }
}

output "reserved" {
  description = "Map of App Service Plan keys to reserved status (true if os_type is Linux)"
  value       = { for k, asp in azurerm_service_plan.this : k => asp.reserved }
}
