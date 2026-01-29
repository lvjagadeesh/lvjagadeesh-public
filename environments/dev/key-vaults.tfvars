# Development Environment - Key Vaults Configuration

# Key Vaults
key_vaults = {
  "main" = {
    name                = "dev-kv-001"
    location            = "East US"
    resource_group_name = "dev-rg"
    sku_name            = "standard"
    tags = {
      Purpose = "Development secrets"
    }
  }
}
