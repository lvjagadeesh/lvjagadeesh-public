# Development Environment - SQL Databases Configuration

# SQL Databases
sql_databases = {
  "main" = {
    name      = "dev-db"
    server_id = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/dev-rg/providers/Microsoft.Sql/servers/dev-sqlserver-001"
    sku_name  = "Basic"
    tags = {
      Purpose = "Development database"
    }
  }
}
