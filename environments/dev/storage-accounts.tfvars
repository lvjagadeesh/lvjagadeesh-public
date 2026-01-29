# Development Environment - Storage Accounts Configuration

# Storage Accounts
storage_accounts = {
  "main" = {
    name                     = "devstorageacct001"
    resource_group_name      = "dev-rg"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    tags = {
      Purpose = "Development storage"
    }
  }
}
