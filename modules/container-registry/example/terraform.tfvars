container_registry_name     = "exampleacr"
resource_group_name         = "example-rg"
location                    = "East US"
sku                         = "Standard"
admin_enabled               = false
georeplications             = []
network_rule_default_action = "Deny"
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}
