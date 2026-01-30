sql_servers = {
  primary = {
    name                         = "primary-sqlserver-prod"
    resource_group_name          = "example-rg"
    location                     = "East US"
    version                      = "12.0"
    administrator_login          = "sqladmin"
    administrator_login_password = "REPLACE_WITH_SECURE_PASSWORD" # Use Azure Key Vault
    minimum_tls_version          = "1.2"
    azuread_admin_login          = "admin@example.com"
    azuread_admin_object_id      = "00000000-0000-0000-0000-000000000000"
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      Purpose     = "Primary Database"
    }
  }

  secondary = {
    name                         = "secondary-sqlserver-prod"
    resource_group_name          = "example-rg"
    location                     = "West US"
    version                      = "12.0"
    administrator_login          = "sqladmin"
    administrator_login_password = "REPLACE_WITH_SECURE_PASSWORD" # Use Azure Key Vault
    minimum_tls_version          = "1.2"
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      Purpose     = "Secondary Database"
    }
  }

  development = {
    name                         = "dev-sqlserver-test"
    resource_group_name          = "example-dev-rg"
    location                     = "Central US"
    version                      = "12.0"
    administrator_login          = "devadmin"
    administrator_login_password = "REPLACE_WITH_DEV_PASSWORD" # Use Azure Key Vault
    minimum_tls_version          = "1.2"
    azuread_admin_login          = "devadmin@example.com"
    azuread_admin_object_id      = "11111111-1111-1111-1111-111111111111"
    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
      Purpose     = "Development Testing"
    }
  }
}
