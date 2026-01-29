# Production Environment - App Service Plans Configuration

# App Service Plans
app_service_plans = {
  "main" = {
    name                = "prod-asp"
    location            = "East US"
    resource_group_name = "prod-rg"
    os_type             = "Linux"
    sku_name            = "P1v2"
    tags = {
      Purpose = "Production app hosting with premium tier"
    }
  }
}
