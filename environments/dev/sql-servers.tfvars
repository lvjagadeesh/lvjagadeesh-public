# Development Environment - SQL Servers Configuration

# SQL Servers
sql_servers = {
  "main" = {
    name                         = "dev-sqlserver-001"
    resource_group_name          = "dev-rg"
    location                     = "East US"
    version                      = "12.0"
    administrator_login          = "sqladmin"
    administrator_login_password = "REPLACE_WITH_SECURE_PASSWORD" # Use Azure Key Vault or GitHub Secrets
    tags = {
      Purpose = "Development database server"
    }
  }
}
