# Staging Environment - Container Registries Configuration

# Container Registries
container_registries = {
  "main" = {
    name                = "stagingacr001"
    resource_group_name = "staging-rg"
    location            = "East US"
    sku                 = "Standard"
    admin_enabled       = true
    tags = {
      Purpose = "Staging container images"
    }
  }
}
