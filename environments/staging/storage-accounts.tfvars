# Staging Environment - Storage Accounts Configuration

# Storage Accounts
storage_accounts = {
  "main" = {
    name                     = "stagingstorageacct001"
    resource_group_name      = "staging-rg"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    tags = {
      Purpose = "Staging storage with geo-redundancy"
    }
  }
}
