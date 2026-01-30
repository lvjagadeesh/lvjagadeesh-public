output "vnet_ids" {
  description = "Map of virtual network keys to IDs"
  value       = { for k, v in azurerm_virtual_network.this : k => v.id }
}

output "vnet_names" {
  description = "Map of virtual network keys to names"
  value       = { for k, v in azurerm_virtual_network.this : k => v.name }
}

output "subnet_ids" {
  description = "Map of subnet keys (vnet_key-subnet_name) to IDs"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "subnets_by_vnet" {
  description = "Map of virtual network keys to their subnet IDs"
  value = {
    for vnet_key, vnet in var.virtual_networks :
    vnet_key => {
      for subnet in try(vnet.subnets, []) :
      subnet.name => azurerm_subnet.this["${vnet_key}-${subnet.name}"].id
    }
  }
}
