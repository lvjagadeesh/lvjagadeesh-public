resource "azurerm_mssql_database" "this" {
  name           = var.database_name
  server_id      = var.sql_server_id
  collation      = var.collation
  license_type   = var.license_type
  max_size_gb    = var.max_size_gb
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant
  tags           = var.tags
}
