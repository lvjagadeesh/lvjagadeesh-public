app_service_plan_name = "example-asp"
location              = "East US"
resource_group_name   = "example-rg"
os_type               = "Linux"
sku_name              = "P1v2"
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}
