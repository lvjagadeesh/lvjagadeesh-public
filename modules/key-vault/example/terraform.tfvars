key_vaults = {
  primary = {
    name                     = "primary-keyvault"
    location                 = "East US"
    resource_group_name      = "example-rg"
    sku_name                 = "standard"
    soft_delete_retention_days = 90
    purge_protection_enabled = true
    network_acls_bypass      = "AzureServices"
    network_acls_default_action = "Deny"
    key_permissions          = ["Get", "List", "Create", "Delete", "Update"]
    secret_permissions       = ["Get", "List", "Set", "Delete"]
    certificate_permissions  = ["Get", "List", "Create", "Delete"]
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      Purpose     = "Primary"
    }
  }

  secondary = {
    name                     = "secondary-keyvault"
    location                 = "West US"
    resource_group_name      = "example-rg"
    sku_name                 = "premium"
    soft_delete_retention_days = 30
    purge_protection_enabled = true
    network_acls_bypass      = "AzureServices"
    network_acls_default_action = "Allow"
    enabled_for_deployment   = true
    enabled_for_disk_encryption = true
    public_network_access_enabled = true
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      Purpose     = "Secondary"
    }
  }

  development = {
    name                     = "dev-keyvault"
    location                 = "Central US"
    resource_group_name      = "example-rg"
    sku_name                 = "standard"
    soft_delete_retention_days = 7
    purge_protection_enabled = false
    network_acls_bypass      = "AzureServices"
    network_acls_default_action = "Allow"
    enabled_for_template_deployment = true
    rbac_authorization_enabled = false
    create_default_access_policy = true
    key_permissions          = ["Get", "List"]
    secret_permissions       = ["Get", "List"]
    certificate_permissions  = ["Get", "List"]
    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
      Purpose     = "Testing"
    }
  }
}
