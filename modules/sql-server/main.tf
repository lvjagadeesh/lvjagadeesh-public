resource "azurerm_mssql_server" "this" {
  for_each = var.sql_servers

  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = each.value.version
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_login_password
  minimum_tls_version          = each.value.minimum_tls_version
  tags                         = each.value.tags

  dynamic "azuread_administrator" {
    for_each = each.value.azuread_admin_login != null && each.value.azuread_admin_object_id != null ? [1] : []
    content {
      login_username = each.value.azuread_admin_login
      object_id      = each.value.azuread_admin_object_id
    }
  }
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  for_each = var.sql_servers

  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.this[each.key].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
