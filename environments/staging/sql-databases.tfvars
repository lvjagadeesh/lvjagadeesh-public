# Staging Environment - SQL Databases Configuration

# SQL Databases
sql_databases = {
  "main" = {
    name      = "staging-db"
    server_id = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/staging-rg/providers/Microsoft.Sql/servers/staging-sqlserver-001"
    sku_name  = "S0"
    tags = {
      Purpose = "Staging database"
    }
  }
}
