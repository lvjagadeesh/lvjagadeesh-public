# Production Environment - Container Registries Configuration

# Container Registries
container_registries = {
  "main" = {
    name                = "prodacr001"
    resource_group_name = "prod-rg"
    location            = "East US"
    sku                 = "Premium"
    admin_enabled       = false
    tags = {
      Purpose = "Production container images"
    }
  }
}
