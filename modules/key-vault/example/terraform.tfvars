key_vault_name               = "example-keyvault"
location                     = "East US"
resource_group_name          = "example-rg"
sku_name                     = "standard"
soft_delete_retention_days   = 90
purge_protection_enabled     = true
network_acls_bypass          = "AzureServices"
network_acls_default_action  = "Deny"
key_permissions              = ["Get", "List", "Create", "Delete", "Update"]
secret_permissions           = ["Get", "List", "Set", "Delete"]
certificate_permissions      = ["Get", "List", "Create", "Delete"]
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}
