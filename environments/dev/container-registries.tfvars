# Development Environment - Container Registries Configuration

# Container Registries
container_registries = {
  "main" = {
    name                = "devacr001"
    resource_group_name = "dev-rg"
    location            = "East US"
    sku                 = "Basic"
    admin_enabled       = true
    tags = {
      Purpose = "Development container images"
    }
  }
}
