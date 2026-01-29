database_name   = "example-db"
sql_server_id   = "/subscriptions/xxxx/resourceGroups/example-rg/providers/Microsoft.Sql/servers/example-sqlserver"
collation       = "SQL_Latin1_General_CP1_CI_AS"
license_type    = "LicenseIncluded"
max_size_gb     = 2
sku_name        = "S0"
zone_redundant  = false
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}
