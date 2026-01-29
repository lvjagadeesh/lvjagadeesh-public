# Development Environment - App Service Plans Configuration

# App Service Plans
app_service_plans = {
  "main" = {
    name                = "dev-asp"
    location            = "East US"
    resource_group_name = "dev-rg"
    os_type             = "Linux"
    sku_name            = "B1"
    tags = {
      Purpose = "Development app hosting"
    }
  }
}
