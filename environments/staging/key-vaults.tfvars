# Staging Environment - Key Vaults Configuration

# Key Vaults
key_vaults = {
  "main" = {
    name                = "staging-kv-001"
    location            = "East US"
    resource_group_name = "staging-rg"
    sku_name            = "standard"
    tags = {
      Purpose = "Staging secrets"
    }
  }
}
