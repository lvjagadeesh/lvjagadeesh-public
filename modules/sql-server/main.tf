resource "azurerm_mssql_server" "this" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_server_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = var.minimum_tls_version
  tags                         = var.tags

  azuread_administrator {
    login_username = var.azuread_admin_login
    object_id      = var.azuread_admin_object_id
  }
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
