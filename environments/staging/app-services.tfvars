# Staging Environment - App Services Configuration

# App Services
app_services = {
  "main" = {
    name                = "staging-app-001"
    location            = "East US"
    resource_group_name = "staging-rg"
    service_plan_id     = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/staging-rg/providers/Microsoft.Web/serverfarms/staging-asp"
    site_config = {
      always_on = true
    }
    tags = {
      Purpose = "Staging web app"
    }
  }
}
