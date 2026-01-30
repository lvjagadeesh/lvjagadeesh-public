# Staging Environment - App Service Plans Configuration

# App Service Plans
app_service_plans = {
  "main" = {
    name                = "staging-asp"
    location            = "East US"
    resource_group_name = "staging-rg"
    os_type             = "Linux"
    sku_name            = "S1"
    tags = {
      Purpose = "Staging app hosting"
    }
  }
}
