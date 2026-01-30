output "key_vaults" {
  description = "Map of all key vaults created with their key attributes"
  value = {
    for k, kv in azurerm_key_vault.this : k => {
      id                              = kv.id
      name                            = kv.name
      vault_uri                       = kv.vault_uri
      tenant_id                       = kv.tenant_id
      location                        = kv.location
      resource_group_name             = kv.resource_group_name
      sku_name                        = kv.sku_name
      soft_delete_retention_days      = kv.soft_delete_retention_days
      purge_protection_enabled        = kv.purge_protection_enabled
      enabled_for_deployment          = kv.enabled_for_deployment
      enabled_for_disk_encryption     = kv.enabled_for_disk_encryption
      enabled_for_template_deployment = kv.enabled_for_template_deployment
      rbac_authorization_enabled      = kv.rbac_authorization_enabled
      public_network_access_enabled   = kv.public_network_access_enabled
    }
  }
}

output "key_vault_ids" {
  description = "Map of key vault keys to IDs"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.id }
}

output "key_vault_names" {
  description = "Map of key vault keys to names"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.name }
}

output "key_vault_uris" {
  description = "Map of key vault keys to URIs"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.vault_uri }
}

output "key_vault_tenant_ids" {
  description = "Map of key vault keys to tenant IDs"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.tenant_id }
}

output "key_vault_locations" {
  description = "Map of key vault keys to locations"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.location }
}

output "key_vault_resource_group_names" {
  description = "Map of key vault keys to resource group names"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.resource_group_name }
}

output "key_vault_sku_names" {
  description = "Map of key vault keys to SKU names"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.sku_name }
}

output "key_vault_soft_delete_retention_days" {
  description = "Map of key vault keys to soft delete retention days"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.soft_delete_retention_days }
}

output "key_vault_purge_protection_enabled" {
  description = "Map of key vault keys to purge protection enabled status"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.purge_protection_enabled }
}

output "key_vault_enabled_for_deployment" {
  description = "Map of key vault keys to enabled for deployment status"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.enabled_for_deployment }
}

output "key_vault_enabled_for_disk_encryption" {
  description = "Map of key vault keys to enabled for disk encryption status"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.enabled_for_disk_encryption }
}

output "key_vault_enabled_for_template_deployment" {
  description = "Map of key vault keys to enabled for template deployment status"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.enabled_for_template_deployment }
}

output "key_vault_rbac_authorization_enabled" {
  description = "Map of key vault keys to RBAC authorization enabled status"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.rbac_authorization_enabled }
}

output "key_vault_public_network_access_enabled" {
  description = "Map of key vault keys to public network access enabled status"
  value       = { for k, kv in azurerm_key_vault.this : k => kv.public_network_access_enabled }
}
