output "database_id" {
  description = "The ID of the SQL Database"
  value       = azurerm_mssql_database.this.id
}

output "database_name" {
  description = "The name of the SQL Database"
  value       = azurerm_mssql_database.this.name
}
