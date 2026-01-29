resource "azurerm_linux_web_app" "this" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
  tags                = var.tags

  site_config {
    always_on = var.always_on

    application_stack {
      docker_image_name   = var.docker_image_name
      docker_registry_url = var.docker_registry_url
    }
  }

  app_settings = var.app_settings

  identity {
    type = "SystemAssigned"
  }
}
