# App Service Plans Configuration
# Create multiple App Service Plans with different configurations

app_service_plans = {
  # Linux App Service Plan for Web Apps
  "web-linux-plan" = {
    name                = "example-web-linux-asp"
    location            = "East US"
    resource_group_name = "example-rg"
    os_type             = "Linux"
    sku_name            = "P1v2"

    # Enable zone balancing for high availability
    zone_balancing_enabled = true

    # Optional: Enable per-site scaling
    per_site_scaling_enabled = false

    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
      Project     = "WebApp"
      Purpose     = "Linux Web Application"
    }
  }

  # Windows App Service Plan for .NET Apps
  "dotnet-windows-plan" = {
    name                = "example-dotnet-windows-asp"
    location            = "East US"
    resource_group_name = "example-rg"
    os_type             = "Windows"
    sku_name            = "P2v3"

    # Higher worker count for production workload
    worker_count = 3

    # Enable per-site scaling for better resource utilization
    per_site_scaling_enabled = true

    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      Project     = "DotNetApp"
      Purpose     = "Windows .NET Application"
    }
  }

  # Premium Linux Plan with Elastic Premium SKU
  "api-elastic-plan" = {
    name                = "example-api-elastic-asp"
    location            = "West US"
    resource_group_name = "example-rg"
    os_type             = "Linux"
    sku_name            = "EP1"

    # Configure elastic scaling for Functions or API Apps
    maximum_elastic_worker_count = 20

    # Enable zone balancing for high availability
    zone_balancing_enabled = true

    tags = {
      Environment = "Staging"
      ManagedBy   = "Terraform"
      Project     = "APIService"
      Purpose     = "Elastic Premium for APIs"
    }

    # Optional: Custom timeouts
    timeouts = {
      create = "90m"
      read   = "5m"
      update = "90m"
      delete = "90m"
    }
  }
}

# Example with App Service Environment (commented out as ASE is not commonly available)
# app_service_plans = {
#   "isolated-plan" = {
#     name                       = "example-isolated-asp"
#     location                   = "East US"
#     resource_group_name        = "example-rg"
#     os_type                    = "Linux"
#     sku_name                   = "I1v2"
#     app_service_environment_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Web/hostingEnvironments/example-ase"
#
#     tags = {
#       Environment = "Production"
#       ManagedBy   = "Terraform"
#       Security    = "Isolated"
#     }
#   }
# }
