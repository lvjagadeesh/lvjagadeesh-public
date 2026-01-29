output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.this.id
}

output "app_service_plan_name" {
  description = "The name of the App Service Plan"
  value       = azurerm_service_plan.this.name
}

output "location" {
  description = "The Azure region where the App Service Plan is located"
  value       = azurerm_service_plan.this.location
}

output "resource_group_name" {
  description = "The name of the resource group containing the App Service Plan"
  value       = azurerm_service_plan.this.resource_group_name
}

output "os_type" {
  description = "The OS type for the App Service Plan"
  value       = azurerm_service_plan.this.os_type
}

output "sku_name" {
  description = "The SKU name of the App Service Plan"
  value       = azurerm_service_plan.this.sku_name
}

output "kind" {
  description = "The kind of the App Service Plan"
  value       = azurerm_service_plan.this.kind
}

output "reserved" {
  description = "Whether this is a reserved Service Plan Type (true if os_type is Linux)"
  value       = azurerm_service_plan.this.reserved
}

output "app_service_environment_id" {
  description = "The ID of the App Service Environment used by the Service Plan (if applicable)"
  value       = azurerm_service_plan.this.app_service_environment_id
}

output "maximum_elastic_worker_count" {
  description = "The maximum number of workers for an Elastic SKU Service Plan"
  value       = azurerm_service_plan.this.maximum_elastic_worker_count
}

output "worker_count" {
  description = "The number of workers allocated to the App Service Plan"
  value       = azurerm_service_plan.this.worker_count
}

output "per_site_scaling_enabled" {
  description = "Whether per site scaling is enabled"
  value       = azurerm_service_plan.this.per_site_scaling_enabled
}

output "zone_balancing_enabled" {
  description = "Whether zone balancing is enabled for the Service Plan"
  value       = azurerm_service_plan.this.zone_balancing_enabled
}

output "tags" {
  description = "The tags assigned to the App Service Plan"
  value       = azurerm_service_plan.this.tags
}
