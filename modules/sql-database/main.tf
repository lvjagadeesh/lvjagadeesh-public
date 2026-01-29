resource "azurerm_mssql_database" "this" {
  for_each = var.sql_databases

  name           = each.value.name
  server_id      = each.value.server_id
  collation      = each.value.collation
  license_type   = each.value.license_type
  max_size_gb    = each.value.max_size_gb
  sku_name       = each.value.sku_name
  zone_redundant = each.value.zone_redundant
  tags           = each.value.tags
}
