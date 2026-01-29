storage_account_name         = "examplestorageacct"
resource_group_name          = "example-rg"
location                     = "East US"
account_tier                 = "Standard"
account_replication_type     = "LRS"
account_kind                 = "StorageV2"
access_tier                  = "Hot"
min_tls_version              = "TLS1_2"
blob_retention_days          = 7
network_rules_default_action = "Deny"
network_rules_bypass         = ["AzureServices"]
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}
