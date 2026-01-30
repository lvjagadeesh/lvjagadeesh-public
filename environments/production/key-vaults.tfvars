# Production Environment - Key Vaults Configuration

# Key Vaults
key_vaults = {
  "main" = {
    name                = "prod-kv-001"
    location            = "East US"
    resource_group_name = "prod-rg"
    sku_name            = "premium"
    tags = {
      Purpose = "Production secrets with premium features"
    }
  }
}
