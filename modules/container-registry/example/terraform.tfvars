# Basic example showing minimal required configuration for the Container Registry module

# Required variables
container_registry_name = "exampleacr"
resource_group_name     = "example-rg"
location                = "East US"

# Optional core configuration
sku           = "Standard"
admin_enabled = false

# Optional: Network rule set (basic configuration)
# Uncomment to restrict network access
# network_rule_set = {
#   default_action = "Deny"
# }

# Tags
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}

