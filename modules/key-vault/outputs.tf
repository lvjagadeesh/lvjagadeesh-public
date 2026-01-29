output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.this.vault_uri
}

output "key_vault_tenant_id" {
  description = "The tenant ID of the Key Vault"
  value       = azurerm_key_vault.this.tenant_id
}

output "key_vault_location" {
  description = "The location of the Key Vault"
  value       = azurerm_key_vault.this.location
}

output "key_vault_resource_group_name" {
  description = "The resource group name of the Key Vault"
  value       = azurerm_key_vault.this.resource_group_name
}

output "key_vault_sku_name" {
  description = "The SKU name of the Key Vault"
  value       = azurerm_key_vault.this.sku_name
}

output "key_vault_soft_delete_retention_days" {
  description = "The soft delete retention days of the Key Vault"
  value       = azurerm_key_vault.this.soft_delete_retention_days
}

output "key_vault_purge_protection_enabled" {
  description = "Whether purge protection is enabled for the Key Vault"
  value       = azurerm_key_vault.this.purge_protection_enabled
}

output "key_vault_enabled_for_deployment" {
  description = "Whether the Key Vault is enabled for deployment"
  value       = azurerm_key_vault.this.enabled_for_deployment
}

output "key_vault_enabled_for_disk_encryption" {
  description = "Whether the Key Vault is enabled for disk encryption"
  value       = azurerm_key_vault.this.enabled_for_disk_encryption
}

output "key_vault_enabled_for_template_deployment" {
  description = "Whether the Key Vault is enabled for template deployment"
  value       = azurerm_key_vault.this.enabled_for_template_deployment
}

output "key_vault_rbac_authorization_enabled" {
  description = "Whether RBAC authorization is enabled for the Key Vault"
  value       = azurerm_key_vault.this.rbac_authorization_enabled
}

output "key_vault_public_network_access_enabled" {
  description = "Whether public network access is enabled for the Key Vault"
  value       = azurerm_key_vault.this.public_network_access_enabled
}
