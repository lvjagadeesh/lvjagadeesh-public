sql_server_name              = "example-sqlserver"
resource_group_name          = "example-rg"
location                     = "East US"
sql_server_version           = "12.0"
administrator_login          = "sqladmin"
administrator_login_password = "REPLACE_WITH_SECURE_PASSWORD" # Use Azure Key Vault
minimum_tls_version          = "1.2"
azuread_admin_login          = "admin@example.com"
azuread_admin_object_id      = "00000000-0000-0000-0000-000000000000"
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}
