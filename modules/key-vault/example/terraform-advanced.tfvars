# ========================================
# Basic Configuration
# ========================================
key_vault_name             = "example-keyvault-adv"
location                   = "East US"
resource_group_name        = "example-rg"
sku_name                   = "premium"
soft_delete_retention_days = 90
purge_protection_enabled   = true

# ========================================
# Core Feature Enablement
# ========================================
enabled_for_deployment          = true
enabled_for_disk_encryption     = true
enabled_for_template_deployment = true
rbac_authorization_enabled      = false
public_network_access_enabled   = true

# ========================================
# Network ACLs Configuration
# ========================================
network_acls_bypass         = "AzureServices"
network_acls_default_action = "Deny"

# Specify allowed IP addresses/CIDR blocks
network_acls_ip_rules = [
  "203.0.113.0/24",
  "198.51.100.42"
]

# Specify allowed VNet subnets (replace with actual subnet IDs)
network_acls_virtual_network_subnet_ids = [
  "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
]

# ========================================
# Default Access Policy Configuration
# ========================================
create_default_access_policy = true
key_permissions              = ["Get", "List", "Create", "Delete", "Update", "Backup", "Restore", "Recover"]
secret_permissions           = ["Get", "List", "Set", "Delete", "Backup", "Restore", "Recover"]
certificate_permissions      = ["Get", "List", "Create", "Delete", "Update", "ManageContacts", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers"]
storage_permissions          = ["Get", "List", "Set", "Delete", "Backup", "Restore", "Recover"]

# ========================================
# Additional Access Policies
# ========================================
additional_access_policies = [
  {
    tenant_id               = "00000000-0000-0000-0000-000000000000"
    object_id               = "11111111-1111-1111-1111-111111111111"
    key_permissions         = ["Get", "List"]
    secret_permissions      = ["Get", "List"]
    certificate_permissions = ["Get", "List"]
    storage_permissions     = []
  },
  {
    tenant_id               = "00000000-0000-0000-0000-000000000000"
    object_id               = "22222222-2222-2222-2222-222222222222"
    application_id          = "33333333-3333-3333-3333-333333333333"
    key_permissions         = ["Get", "List", "Decrypt", "Encrypt"]
    secret_permissions      = ["Get", "List"]
    certificate_permissions = []
    storage_permissions     = []
  }
]

# ========================================
# Contact Information for Notifications
# ========================================
contacts = [
  {
    email = "keyvault-admin@example.com"
    name  = "Key Vault Administrator"
    phone = "+1-555-123-4567"
  },
  {
    email = "security-team@example.com"
    name  = "Security Team"
    phone = "+1-555-987-6543"
  }
]

# ========================================
# Tags
# ========================================
tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
  Project     = "Enterprise Key Vault"
  CostCenter  = "IT-Security"
  Compliance  = "PCI-DSS"
}
