/**
 * GitHub Actions Runner - Linux VM Module
 * Outputs
 */

output "runners" {
  description = "Map of created GitHub Actions Linux VM runners"
  value = {
    for k, r in azurerm_linux_virtual_machine.this : k => {
      id                = r.id
      name              = r.name
      location          = r.location
      resource_group    = r.resource_group_name
      private_ip        = r.private_ip_address
      public_ip         = try(azurerm_public_ip.this[k].ip_address, null)
      vm_size           = r.size
      admin_username    = r.admin_username
    }
  }
}

output "runner_ids" {
  description = "Map of runner keys to VM IDs"
  value = {
    for k, r in azurerm_linux_virtual_machine.this : k => r.id
  }
}

output "runner_names" {
  description = "Map of runner keys to VM names"
  value = {
    for k, r in azurerm_linux_virtual_machine.this : k => r.name
  }
}

output "runner_private_ips" {
  description = "Map of runner keys to private IP addresses"
  value = {
    for k, r in azurerm_linux_virtual_machine.this : k => r.private_ip_address
  }
}

output "runner_public_ips" {
  description = "Map of runner keys to public IP addresses (if enabled)"
  value = {
    for k, pip in azurerm_public_ip.this : k => pip.ip_address
  }
}
