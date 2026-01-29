# Example showing multiple container registries with various configurations

container_registries = {
  # Basic container registry with minimal configuration
  "dev_registry" = {
    name                = "devacr12345"
    resource_group_name = "example-rg"
    location            = "East US"
    sku                 = "Basic"
    admin_enabled       = true
    tags = {
      Environment = "Development"
      Purpose     = "Dev Testing"
      ManagedBy   = "Terraform"
    }
  }

  # Standard container registry with network rules
  "staging_registry" = {
    name                = "stagingacr12345"
    resource_group_name = "example-rg"
    location            = "East US"
    sku                 = "Standard"
    admin_enabled       = false
    public_network_access_enabled = false
    network_rule_bypass_option    = "AzureServices"
    network_rule_set = {
      default_action = "Deny"
      ip_rule = [
        {
          action   = "Allow"
          ip_range = "10.0.0.0/24"
        }
      ]
    }
    tags = {
      Environment = "Staging"
      Purpose     = "Pre-Production"
      ManagedBy   = "Terraform"
    }
  }

  # Premium container registry with geo-replication and advanced features
  "prod_registry" = {
    name                          = "prodacr12345"
    resource_group_name           = "example-rg"
    location                      = "East US"
    sku                           = "Premium"
    admin_enabled                 = false
    public_network_access_enabled = true
    zone_redundancy_enabled       = true
    quarantine_policy_enabled     = true
    data_endpoint_enabled         = true
    retention_policy_in_days      = 30
    trust_policy_enabled          = true
    georeplications = [
      {
        location                  = "West US"
        zone_redundancy_enabled   = true
        regional_endpoint_enabled = true
        tags = {
          ReplicaRegion = "West"
        }
      },
      {
        location                  = "Central US"
        zone_redundancy_enabled   = false
        regional_endpoint_enabled = false
        tags = {
          ReplicaRegion = "Central"
        }
      }
    ]
    identity = {
      type = "SystemAssigned"
    }
    tags = {
      Environment = "Production"
      Purpose     = "Production Workloads"
      ManagedBy   = "Terraform"
      CostCenter  = "Engineering"
    }
  }
}

