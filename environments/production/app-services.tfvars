# Production Environment - App Services Configuration

# App Services
app_services = {
  "main" = {
    name                = "prod-app-001"
    location            = "East US"
    resource_group_name = "prod-rg"
    service_plan_id     = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/prod-rg/providers/Microsoft.Web/serverfarms/prod-asp"
    https_only          = true
    site_config = {
      always_on = true
    }
    tags = {
      Purpose = "Production web app"
    }
  }
}
