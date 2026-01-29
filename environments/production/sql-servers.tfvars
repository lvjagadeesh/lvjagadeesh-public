# Production Environment - SQL Servers Configuration

# SQL Servers
sql_servers = {
  "main" = {
    name                         = "prod-sqlserver-001"
    resource_group_name          = "prod-rg"
    location                     = "East US"
    version                      = "12.0"
    administrator_login          = "sqladmin"
    administrator_login_password = "REPLACE_WITH_SECURE_PASSWORD"
    minimum_tls_version          = "1.2"
    tags = {
      Purpose = "Production database server"
    }
  }
}
