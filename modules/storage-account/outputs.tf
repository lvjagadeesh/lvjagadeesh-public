output "storage_accounts" {
  description = "Map of all storage accounts created (excluding sensitive data)"
  value = {
    for k, sa in azurerm_storage_account.this : k => {
      id                    = sa.id
      name                  = sa.name
      primary_blob_endpoint = sa.primary_blob_endpoint
      resource_group_name   = sa.resource_group_name
      location              = sa.location
    }
  }
}

output "storage_account_ids" {
  description = "Map of storage account keys to IDs"
  value       = { for k, sa in azurerm_storage_account.this : k => sa.id }
}

output "storage_account_names" {
  description = "Map of storage account keys to names"
  value       = { for k, sa in azurerm_storage_account.this : k => sa.name }
}

output "primary_blob_endpoints" {
  description = "Map of storage account keys to primary blob endpoints"
  value       = { for k, sa in azurerm_storage_account.this : k => sa.primary_blob_endpoint }
}

output "primary_access_keys" {
  description = "Map of storage account keys to primary access keys"
  value       = { for k, sa in azurerm_storage_account.this : k => sa.primary_access_key }
  sensitive   = true
}
