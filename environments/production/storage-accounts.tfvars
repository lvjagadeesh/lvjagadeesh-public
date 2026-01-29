# Production Environment - Storage Accounts Configuration

# Storage Accounts
storage_accounts = {
  "main" = {
    name                     = "prodstorageacct001"
    resource_group_name      = "prod-rg"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    enable_https_traffic_only = true
    min_tls_version          = "TLS1_2"
    tags = {
      Purpose = "Production storage with enhanced security"
    }
  }
}
