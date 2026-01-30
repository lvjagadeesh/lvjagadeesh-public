# Development Environment - App Services Configuration

# App Services
app_services = {
  "main" = {
    name                = "dev-app-001"
    location            = "East US"
    resource_group_name = "dev-rg"
    service_plan_id     = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/dev-rg/providers/Microsoft.Web/serverfarms/dev-asp"
    site_config = {
      always_on = false
    }
    tags = {
      Purpose = "Development web app"
    }
  }
}
