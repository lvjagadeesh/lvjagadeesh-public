# Comprehensive example showing ALL available configuration options for the Container Registry module

# Required variables
container_registry_name = "premiumacr2024"
resource_group_name     = "production-rg"
location                = "East US"

# Optional core configuration
sku                           = "Premium" # Required for many advanced features
admin_enabled                 = false
public_network_access_enabled = true
quarantine_policy_enabled     = false # Premium SKU only
zone_redundancy_enabled       = false # Premium SKU only, set at creation
export_policy_enabled         = true
anonymous_pull_enabled        = false
data_endpoint_enabled         = true # Premium SKU only
network_rule_bypass_option    = "AzureServices"

# Geo-replications (Premium SKU only)
georeplications = [
  {
    location                  = "West US"
    zone_redundancy_enabled   = true
    regional_endpoint_enabled = false
    tags = {
      ReplicaLocation = "west"
    }
  },
  {
    location                  = "North Europe"
    zone_redundancy_enabled   = false
    regional_endpoint_enabled = true
    tags = {
      ReplicaLocation = "europe"
    }
  }
]

# Network rule set with IP rules
network_rule_set = {
  default_action = "Deny"
  ip_rule = [
    {
      action   = "Allow"
      ip_range = "203.0.113.0/24"
    },
    {
      action   = "Allow"
      ip_range = "198.51.100.5"
    }
  ]
}

# Retention policy for untagged manifests in days (Premium SKU only)
# Value between 0 and 365 days
retention_policy_in_days = 7

# Trust policy for content trust (Premium SKU only)
trust_policy_enabled = true

# Managed identity configuration
identity = {
  type = "SystemAssigned"
  # identity_ids is only needed for UserAssigned or SystemAssigned, UserAssigned
  # identity_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/example-identity"]
}

# Customer-managed key encryption (Premium SKU only)
# Uncomment to enable encryption with customer-managed keys
# encryption = {
#   key_vault_key_id   = "https://example-keyvault.vault.azure.net/keys/example-key/example-version"
#   identity_client_id = "00000000-0000-0000-0000-000000000000"
# }

# Tags
tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
  CostCenter  = "Engineering"
  Project     = "ContainerPlatform"
}
