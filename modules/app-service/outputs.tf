# ========================================
# BASIC OUTPUTS
# ========================================

output "app_service_id" {
  description = "The ID of the App Service"
  value       = azurerm_linux_web_app.this.id
}

output "app_service_name" {
  description = "The name of the App Service"
  value       = azurerm_linux_web_app.this.name
}

output "location" {
  description = "The Azure region where the App Service is deployed"
  value       = azurerm_linux_web_app.this.location
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_linux_web_app.this.resource_group_name
}

output "kind" {
  description = "The kind of the App Service"
  value       = azurerm_linux_web_app.this.kind
}

# ========================================
# HOSTNAME OUTPUTS
# ========================================

output "default_hostname" {
  description = "The default hostname of the App Service"
  value       = azurerm_linux_web_app.this.default_hostname
}

output "custom_domain_verification_id" {
  description = "The identifier used by App Service to perform domain ownership verification via DNS TXT record"
  value       = azurerm_linux_web_app.this.custom_domain_verification_id
}

output "possible_outbound_ip_addresses" {
  description = "A comma-separated list of outbound IP addresses - not exhaustive"
  value       = azurerm_linux_web_app.this.possible_outbound_ip_addresses
}

output "possible_outbound_ip_address_list" {
  description = "A list of possible outbound IP addresses - not exhaustive"
  value       = azurerm_linux_web_app.this.possible_outbound_ip_address_list
}

output "outbound_ip_addresses" {
  description = "A comma-separated list of outbound IP addresses currently in use"
  value       = azurerm_linux_web_app.this.outbound_ip_addresses
}

output "outbound_ip_address_list" {
  description = "A list of outbound IP addresses currently in use"
  value       = azurerm_linux_web_app.this.outbound_ip_address_list
}

# ========================================
# IDENTITY OUTPUTS
# ========================================

output "identity_principal_id" {
  description = "The principal ID of the system-assigned managed identity"
  value       = try(azurerm_linux_web_app.this.identity[0].principal_id, null)
}

output "identity_tenant_id" {
  description = "The tenant ID of the system-assigned managed identity"
  value       = try(azurerm_linux_web_app.this.identity[0].tenant_id, null)
}

output "identity" {
  description = "The full identity block with type, principal_id, tenant_id, and identity_ids"
  value       = azurerm_linux_web_app.this.identity
}

# ========================================
# SITE CONFIG OUTPUTS
# ========================================

output "site_config" {
  description = "The site_config block of the App Service"
  value       = azurerm_linux_web_app.this.site_config
  sensitive   = true
}

output "site_credential" {
  description = "The site credentials for publishing"
  value       = azurerm_linux_web_app.this.site_credential
  sensitive   = true
}

# ========================================
# HOSTING OUTPUTS
# ========================================

output "hosting_environment_id" {
  description = "The ID of the App Service Environment used by the App Service"
  value       = azurerm_linux_web_app.this.hosting_environment_id
}

output "service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_linux_web_app.this.service_plan_id
}

# ========================================
# ADVANCED OUTPUTS
# ========================================

output "connection_strings" {
  description = "Connection strings configured for the App Service"
  value       = azurerm_linux_web_app.this.connection_string
  sensitive   = true
}

output "client_certificate_mode" {
  description = "The client certificate mode of the App Service"
  value       = azurerm_linux_web_app.this.client_certificate_mode
}

output "client_certificate_enabled" {
  description = "Whether client certificates are enabled"
  value       = azurerm_linux_web_app.this.client_certificate_enabled
}

output "https_only" {
  description = "Whether HTTPS only is enabled"
  value       = azurerm_linux_web_app.this.https_only
}

output "public_network_access_enabled" {
  description = "Whether public network access is enabled"
  value       = azurerm_linux_web_app.this.public_network_access_enabled
}

output "virtual_network_subnet_id" {
  description = "The subnet ID used for VNet integration"
  value       = azurerm_linux_web_app.this.virtual_network_subnet_id
}

# ========================================
# UTILITY OUTPUTS
# ========================================

output "app_service_url" {
  description = "The URL of the App Service (HTTPS)"
  value       = "https://${azurerm_linux_web_app.this.default_hostname}"
}

output "scm_url" {
  description = "The SCM (Kudu) URL of the App Service"
  value       = "https://${azurerm_linux_web_app.this.name}.scm.azurewebsites.net"
}

output "tags" {
  description = "Tags applied to the App Service"
  value       = azurerm_linux_web_app.this.tags
}
