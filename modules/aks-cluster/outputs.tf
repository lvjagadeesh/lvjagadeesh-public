# ============================================================================
# CLUSTER BASIC OUTPUTS
# ============================================================================

output "cluster_ids" {
  description = "Map of cluster keys to IDs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.id }
}

output "cluster_names" {
  description = "Map of cluster keys to names"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.name }
}

output "locations" {
  description = "Map of cluster keys to Azure regions"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.location }
}

output "resource_group_names" {
  description = "Map of cluster keys to resource group names"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.resource_group_name }
}

output "kubernetes_versions" {
  description = "Map of cluster keys to Kubernetes versions"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.kubernetes_version }
}

# ============================================================================
# CLUSTER FQDN AND DNS
# ============================================================================

output "fqdns" {
  description = "Map of cluster keys to FQDNs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.fqdn }
}

output "private_fqdns" {
  description = "Map of cluster keys to private FQDNs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.private_fqdn }
}

output "portal_fqdns" {
  description = "Map of cluster keys to portal FQDNs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.portal_fqdn }
}

# ============================================================================
# KUBE CONFIG
# ============================================================================

output "kube_configs" {
  description = "Map of cluster keys to raw Kubernetes configurations"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.kube_config_raw }
  sensitive   = true
}

output "kube_admin_configs" {
  description = "Map of cluster keys to admin Kubernetes configurations"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.kube_admin_config_raw }
  sensitive   = true
}

# ============================================================================
# IDENTITY OUTPUTS
# ============================================================================

output "identities" {
  description = "Map of cluster keys to identity blocks"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.identity }
}

output "identity_principal_ids" {
  description = "Map of cluster keys to identity principal IDs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.identity[0].principal_id, null) }
}

output "identity_tenant_ids" {
  description = "Map of cluster keys to identity tenant IDs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.identity[0].tenant_id, null) }
}

output "kubelet_identities" {
  description = "Map of cluster keys to kubelet identity configurations"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.kubelet_identity }
}

output "kubelet_identity_client_ids" {
  description = "Map of cluster keys to kubelet identity client IDs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.kubelet_identity[0].client_id, null) }
}

output "kubelet_identity_object_ids" {
  description = "Map of cluster keys to kubelet identity object IDs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.kubelet_identity[0].object_id, null) }
}

output "kubelet_identity_user_assigned_identity_ids" {
  description = "Map of cluster keys to kubelet identity user-assigned identity IDs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.kubelet_identity[0].user_assigned_identity_id, null) }
}

# ============================================================================
# NODE RESOURCE GROUP
# ============================================================================

output "node_resource_groups" {
  description = "Map of cluster keys to auto-generated node resource groups"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.node_resource_group }
}

output "node_resource_group_ids" {
  description = "Map of cluster keys to node resource group IDs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.node_resource_group_id }
}

# ============================================================================
# NETWORK OUTPUTS
# ============================================================================

output "network_profiles" {
  description = "Map of cluster keys to network profile configurations"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.network_profile }
}

output "network_plugins" {
  description = "Map of cluster keys to network plugins"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.network_profile[0].network_plugin, null) }
}

output "service_cidrs" {
  description = "Map of cluster keys to service CIDRs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.network_profile[0].service_cidr, null) }
}

output "dns_service_ips" {
  description = "Map of cluster keys to DNS service IPs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.network_profile[0].dns_service_ip, null) }
}

output "pod_cidrs" {
  description = "Map of cluster keys to pod CIDRs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.network_profile[0].pod_cidr, null) }
}

# ============================================================================
# OIDC AND WORKLOAD IDENTITY
# ============================================================================

output "oidc_issuer_urls" {
  description = "Map of cluster keys to OIDC issuer URLs"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.oidc_issuer_url }
}

# ============================================================================
# KEY VAULT SECRETS PROVIDER
# ============================================================================

output "key_vault_secrets_providers" {
  description = "Map of cluster keys to Key Vault Secrets Provider configurations"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.key_vault_secrets_provider }
}

output "key_vault_secrets_provider_identities" {
  description = "Map of cluster keys to Key Vault Secrets Provider identities"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.key_vault_secrets_provider[0].secret_identity, null) }
}

# ============================================================================
# OMS AGENT
# ============================================================================

output "oms_agents" {
  description = "Map of cluster keys to OMS Agent configurations"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.oms_agent }
}

output "oms_agent_identities" {
  description = "Map of cluster keys to OMS Agent identities"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.oms_agent[0].oms_agent_identity, null) }
}

# ============================================================================
# INGRESS APPLICATION GATEWAY
# ============================================================================

output "ingress_application_gateways" {
  description = "Map of cluster keys to Ingress Application Gateway configurations"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.ingress_application_gateway }
}

output "ingress_application_gateway_identities" {
  description = "Map of cluster keys to Ingress Application Gateway identities"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.ingress_application_gateway[0].ingress_application_gateway_identity, null) }
}

# ============================================================================
# WEB APP ROUTING
# ============================================================================

output "web_app_routing_identities" {
  description = "Map of cluster keys to Web App Routing identities"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => try(v.web_app_routing[0].web_app_routing_identity, null) }
}

# ============================================================================
# HTTP APPLICATION ROUTING
# ============================================================================

output "http_application_routing_zone_names" {
  description = "Map of cluster keys to HTTP application routing zone names"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.http_application_routing_zone_name }
}

# ============================================================================
# CURRENT KUBERNETES VERSION
# ============================================================================

output "current_kubernetes_versions" {
  description = "Map of cluster keys to current Kubernetes versions"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.current_kubernetes_version }
}

# ============================================================================
# PRIVATE CLUSTER DETAILS
# ============================================================================

output "private_cluster_enabled" {
  description = "Map of cluster keys to private cluster enabled status"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.private_cluster_enabled }
}

output "private_cluster_public_fqdn_enabled" {
  description = "Map of cluster keys to private cluster public FQDN enabled status"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.private_cluster_public_fqdn_enabled }
}

# ============================================================================
# AZURE AD RBAC
# ============================================================================

output "azure_ad_rbac_enabled" {
  description = "Map of cluster keys to Azure AD RBAC enabled status"
  value = {
    for k, v in azurerm_kubernetes_cluster.this :
    k => try(v.azure_active_directory_role_based_access_control[0].azure_rbac_enabled, null)
  }
}

output "azure_ad_rbac_tenant_ids" {
  description = "Map of cluster keys to Azure AD RBAC tenant IDs"
  value = {
    for k, v in azurerm_kubernetes_cluster.this :
    k => try(v.azure_active_directory_role_based_access_control[0].tenant_id, null)
  }
}

# ============================================================================
# STORAGE PROFILE
# ============================================================================

output "storage_profiles" {
  description = "Map of cluster keys to storage profile configurations"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.storage_profile }
}

# ============================================================================
# WORKLOAD IDENTITY
# ============================================================================

output "workload_identity_enabled" {
  description = "Map of cluster keys to workload identity enabled status"
  value       = { for k, v in azurerm_kubernetes_cluster.this : k => v.workload_identity_enabled }
}

# ============================================================================
# ALL CLUSTER DETAILS (COMPLETE OBJECT)
# ============================================================================

output "clusters" {
  description = "Map of cluster keys to complete AKS cluster objects with all attributes"
  value       = azurerm_kubernetes_cluster.this
  sensitive   = true
}
