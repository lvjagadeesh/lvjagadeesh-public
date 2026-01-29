output "sql_databases" {
  description = "Map of all SQL databases created with their key attributes"
  value = {
    for k, db in azurerm_mssql_database.this : k => {
      id             = db.id
      name           = db.name
      server_id      = db.server_id
      collation      = db.collation
      license_type   = db.license_type
      max_size_gb    = db.max_size_gb
      sku_name       = db.sku_name
      zone_redundant = db.zone_redundant
    }
  }
}

output "database_ids" {
  description = "Map of database keys to IDs"
  value       = { for k, db in azurerm_mssql_database.this : k => db.id }
}

output "database_names" {
  description = "Map of database keys to names"
  value       = { for k, db in azurerm_mssql_database.this : k => db.name }
}
