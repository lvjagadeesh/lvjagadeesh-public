resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  access_tier              = var.access_tier
  min_tls_version          = var.min_tls_version
  tags                     = var.tags

  blob_properties {
    delete_retention_policy {
      days = var.blob_retention_days
    }
  }

  network_rules {
    default_action = var.network_rules_default_action
    bypass         = var.network_rules_bypass
  }
}
