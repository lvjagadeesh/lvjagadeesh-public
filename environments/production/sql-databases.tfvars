# Production Environment - SQL Databases Configuration

# SQL Databases
sql_databases = {
  "main" = {
    name      = "prod-db"
    server_id = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/prod-rg/providers/Microsoft.Sql/servers/prod-sqlserver-001"
    sku_name  = "S1"
    tags = {
      Purpose = "Production database"
    }
  }
}
