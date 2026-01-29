storage_accounts = {
  "sa1" = {
    name                     = "examplesa01dev"
    resource_group_name      = "example-rg-01"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    access_tier              = "Hot"
    min_tls_version          = "TLS1_2"
    enable_https_traffic_only = true
    blob_properties = {
      versioning_enabled = true
      delete_retention_policy = {
        days = 7
      }
    }
    network_rules = {
      default_action = "Deny"
      bypass         = ["AzureServices"]
      ip_rules       = ["203.0.113.0/24"]
    }
    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
      CostCenter  = "Engineering"
    }
  }
  "sa2" = {
    name                     = "examplesa02prod"
    resource_group_name      = "example-rg-02"
    location                 = "West US"
    account_tier             = "Premium"
    account_replication_type = "ZRS"
    account_kind             = "BlockBlobStorage"
    enable_https_traffic_only = true
    min_tls_version          = "TLS1_3"
    public_network_access_enabled = false
    shared_access_key_enabled = false
    blob_properties = {
      versioning_enabled = true
      change_feed_enabled = true
      delete_retention_policy = {
        days = 30
      }
      container_delete_retention_policy = {
        days = 30
      }
    }
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      CostCenter  = "Operations"
    }
  }
  "sa3" = {
    name                     = "examplesa03data"
    resource_group_name      = "example-rg-03"
    location                 = "Central US"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    account_kind             = "StorageV2"
    access_tier              = "Hot"
    is_hns_enabled           = true
    min_tls_version          = "TLS1_2"
    enable_https_traffic_only = true
    blob_properties = {
      versioning_enabled = true
      delete_retention_policy = {
        days = 14
      }
      restore_policy = {
        days = 7
      }
    }
    static_website = {
      index_document = "index.html"
      error_404_document = "404.html"
    }
    tags = {
      Environment = "Shared"
      ManagedBy   = "Terraform"
      Purpose     = "DataLake"
    }
  }
}
