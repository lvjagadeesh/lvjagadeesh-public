# ========================================
# BASIC OUTPUTS
# ========================================

output "app_service_ids" {
  description = "Map of app service IDs"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.id }
}

output "app_service_names" {
  description = "Map of app service names"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.name }
}

output "locations" {
  description = "Map of Azure regions where the app services are deployed"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.location }
}

output "resource_group_names" {
  description = "Map of resource group names"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.resource_group_name }
}

output "kinds" {
  description = "Map of app service kinds"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.kind }
}

# ========================================
# HOSTNAME OUTPUTS
# ========================================

output "default_hostnames" {
  description = "Map of default hostnames of the app services"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.default_hostname }
}

output "custom_domain_verification_ids" {
  description = "Map of identifiers used by App Service to perform domain ownership verification via DNS TXT record"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.custom_domain_verification_id }
}

output "possible_outbound_ip_addresses" {
  description = "Map of comma-separated lists of outbound IP addresses - not exhaustive"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.possible_outbound_ip_addresses }
}

output "possible_outbound_ip_address_lists" {
  description = "Map of lists of possible outbound IP addresses - not exhaustive"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.possible_outbound_ip_address_list }
}

output "outbound_ip_addresses" {
  description = "Map of comma-separated lists of outbound IP addresses currently in use"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.outbound_ip_addresses }
}

output "outbound_ip_address_lists" {
  description = "Map of lists of outbound IP addresses currently in use"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.outbound_ip_address_list }
}

# ========================================
# IDENTITY OUTPUTS
# ========================================

output "identity_principal_ids" {
  description = "Map of principal IDs of the system-assigned managed identities"
  value       = { for k, v in azurerm_linux_web_app.this : k => try(v.identity[0].principal_id, null) }
}

output "identity_tenant_ids" {
  description = "Map of tenant IDs of the system-assigned managed identities"
  value       = { for k, v in azurerm_linux_web_app.this : k => try(v.identity[0].tenant_id, null) }
}

output "identities" {
  description = "Map of full identity blocks with type, principal_id, tenant_id, and identity_ids"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.identity }
}

# ========================================
# SITE CONFIG OUTPUTS
# ========================================

output "site_configs" {
  description = "Map of site_config blocks of the app services"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.site_config }
  sensitive   = true
}

output "site_credentials" {
  description = "Map of site credentials for publishing"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.site_credential }
  sensitive   = true
}

# ========================================
# HOSTING OUTPUTS
# ========================================

output "hosting_environment_ids" {
  description = "Map of IDs of the App Service Environments used by the app services"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.hosting_environment_id }
}

output "service_plan_ids" {
  description = "Map of IDs of the App Service Plans"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.service_plan_id }
}

# ========================================
# ADVANCED OUTPUTS
# ========================================

output "connection_strings" {
  description = "Map of connection strings configured for the app services"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.connection_string }
  sensitive   = true
}

output "client_certificate_modes" {
  description = "Map of client certificate modes of the app services"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.client_certificate_mode }
}

output "client_certificate_enabled" {
  description = "Map of whether client certificates are enabled"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.client_certificate_enabled }
}

output "https_only" {
  description = "Map of whether HTTPS only is enabled"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.https_only }
}

output "public_network_access_enabled" {
  description = "Map of whether public network access is enabled"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.public_network_access_enabled }
}

output "virtual_network_subnet_ids" {
  description = "Map of subnet IDs used for VNet integration"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.virtual_network_subnet_id }
}

# ========================================
# UTILITY OUTPUTS
# ========================================

output "app_service_urls" {
  description = "Map of URLs of the app services (HTTPS)"
  value       = { for k, v in azurerm_linux_web_app.this : k => "https://${v.default_hostname}" }
}

output "scm_urls" {
  description = "Map of SCM (Kudu) URLs of the app services"
  value       = { for k, v in azurerm_linux_web_app.this : k => "https://${v.name}.scm.azurewebsites.net" }
}

output "tags" {
  description = "Map of tags applied to the app services"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.tags }
}
