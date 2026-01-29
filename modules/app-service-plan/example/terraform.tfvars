# Required variables
app_service_plan_name = "example-asp"
location              = "East US"
resource_group_name   = "example-rg"

# OS type - Valid values: Linux, Windows, WindowsContainer
os_type = "Linux"

# SKU name - Examples: B1, B2, B3, S1, S2, S3, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3
sku_name = "P1v2"

# Optional: App Service Environment ID (required for Isolated SKUs)
# app_service_environment_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Web/hostingEnvironments/example-ase"

# Optional: Maximum number of elastic workers (for Elastic SKUs only)
# maximum_elastic_worker_count = 20

# Optional: Number of workers (instances) - typically 1-30
# worker_count = 3

# Optional: Enable per-site scaling (default: false)
per_site_scaling_enabled = false

# Optional: Enable zone balancing across availability zones (default: false)
# Note: Changing this forces a new resource to be created
zone_balancing_enabled = false

# Optional: Tags
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
  Project     = "Example"
}

# Optional: Custom timeouts
# timeouts = {
#   create = "60m"
#   read   = "5m"
#   update = "60m"
#   delete = "60m"
# }
