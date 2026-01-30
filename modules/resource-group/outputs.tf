output "resource_groups" {
  description = "Map of all resource groups created"
  value = {
    for k, rg in azurerm_resource_group.this : k => {
      name     = rg.name
      id       = rg.id
      location = rg.location
    }
  }
}

output "resource_group_names" {
  description = "Map of resource group keys to names"
  value       = { for k, rg in azurerm_resource_group.this : k => rg.name }
}

output "resource_group_ids" {
  description = "Map of resource group keys to IDs"
  value       = { for k, rg in azurerm_resource_group.this : k => rg.id }
}

output "locations" {
  description = "Map of resource group keys to locations"
  value       = { for k, rg in azurerm_resource_group.this : k => rg.location }
}
