sql_databases = {
  # Primary database for production workload
  "primary-db" = {
    name           = "example-primary-db"
    server_id      = "/subscriptions/xxxx/resourceGroups/example-rg/providers/Microsoft.Sql/servers/example-sqlserver"
    collation      = "SQL_Latin1_General_CP1_CI_AS"
    license_type   = "LicenseIncluded"
    max_size_gb    = 10
    sku_name       = "S1"
    zone_redundant = true
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      Purpose     = "Primary"
    }
  }

  # Secondary database for development
  "dev-db" = {
    name           = "example-dev-db"
    server_id      = "/subscriptions/xxxx/resourceGroups/example-rg/providers/Microsoft.Sql/servers/example-sqlserver"
    collation      = "SQL_Latin1_General_CP1_CI_AS"
    license_type   = "LicenseIncluded"
    max_size_gb    = 2
    sku_name       = "S0"
    zone_redundant = false
    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
      Purpose     = "Development"
    }
  }

  # Testing database
  "test-db" = {
    name           = "example-test-db"
    server_id      = "/subscriptions/xxxx/resourceGroups/example-rg/providers/Microsoft.Sql/servers/example-sqlserver"
    collation      = "SQL_Latin1_General_CP1_CI_AS"
    license_type   = "BasePrice"
    max_size_gb    = 5
    sku_name       = "S0"
    zone_redundant = false
    tags = {
      Environment = "Testing"
      ManagedBy   = "Terraform"
      Purpose     = "QA"
    }
  }
}
