# Staging Environment - SQL Servers Configuration

# SQL Servers
sql_servers = {
  "main" = {
    name                         = "staging-sqlserver-001"
    resource_group_name          = "staging-rg"
    location                     = "East US"
    version                      = "12.0"
    administrator_login          = "sqladmin"
    administrator_login_password = "REPLACE_WITH_SECURE_PASSWORD"
    tags = {
      Purpose = "Staging database server"
    }
  }
}
