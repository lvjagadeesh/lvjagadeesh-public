output "sql_server_id" {
  description = "The ID of the SQL Server"
  value       = azurerm_mssql_server.this.id
}

output "sql_server_name" {
  description = "The name of the SQL Server"
  value       = azurerm_mssql_server.this.name
}

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}
