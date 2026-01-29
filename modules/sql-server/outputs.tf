output "sql_servers" {
  description = "Map of all SQL servers created (excluding sensitive data)"
  value = {
    for k, s in azurerm_mssql_server.this : k => {
      id                          = s.id
      name                        = s.name
      fully_qualified_domain_name = s.fully_qualified_domain_name
      resource_group_name         = s.resource_group_name
      location                    = s.location
      version                     = s.version
    }
  }
}

output "sql_server_ids" {
  description = "Map of SQL server keys to IDs"
  value       = { for k, s in azurerm_mssql_server.this : k => s.id }
}

output "sql_server_names" {
  description = "Map of SQL server keys to names"
  value       = { for k, s in azurerm_mssql_server.this : k => s.name }
}

output "sql_server_fqdns" {
  description = "Map of SQL server keys to fully qualified domain names"
  value       = { for k, s in azurerm_mssql_server.this : k => s.fully_qualified_domain_name }
}
