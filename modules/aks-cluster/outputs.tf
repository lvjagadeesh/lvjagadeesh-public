# ============================================================================
# CLUSTER BASIC OUTPUTS
# ============================================================================

output "cluster_id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "location" {
  description = "The Azure region of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.location
}

output "resource_group_name" {
  description = "The resource group name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.resource_group_name
}

output "kubernetes_version" {
  description = "The Kubernetes version of the cluster"
  value       = azurerm_kubernetes_cluster.this.kubernetes_version
}

# ============================================================================
# CLUSTER FQDN AND DNS
# ============================================================================

output "fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "private_fqdn" {
  description = "The private FQDN for the AKS cluster (if private cluster is enabled)"
  value       = azurerm_kubernetes_cluster.this.private_fqdn
}

output "portal_fqdn" {
  description = "The portal FQDN for the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.portal_fqdn
}

output "cluster_fqdn" {
  description = "The FQDN of the AKS cluster (alias for backward compatibility)"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

# ============================================================================
# KUBE CONFIG
# ============================================================================

output "kube_config" {
  description = "Raw Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "kube_config_raw" {
  description = "Raw Kubernetes configuration as a string"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "kube_admin_config" {
  description = "Admin Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.this.kube_admin_config_raw
  sensitive   = true
}

output "kube_admin_config_raw" {
  description = "Raw admin Kubernetes configuration as a string"
  value       = azurerm_kubernetes_cluster.this.kube_admin_config_raw
  sensitive   = true
}

# ============================================================================
# IDENTITY OUTPUTS
# ============================================================================

output "identity" {
  description = "The identity block of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.identity
}

output "identity_principal_id" {
  description = "The principal ID of the system-assigned or user-assigned identity"
  value       = try(azurerm_kubernetes_cluster.this.identity[0].principal_id, null)
}

output "identity_tenant_id" {
  description = "The tenant ID of the system-assigned or user-assigned identity"
  value       = try(azurerm_kubernetes_cluster.this.identity[0].tenant_id, null)
}

output "kubelet_identity" {
  description = "The kubelet identity configuration"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity
}

output "kubelet_identity_client_id" {
  description = "The client ID of the kubelet identity"
  value       = try(azurerm_kubernetes_cluster.this.kubelet_identity[0].client_id, null)
}

output "kubelet_identity_object_id" {
  description = "The object ID of the kubelet identity"
  value       = try(azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id, null)
}

output "kubelet_identity_user_assigned_identity_id" {
  description = "The user-assigned identity ID of the kubelet identity"
  value       = try(azurerm_kubernetes_cluster.this.kubelet_identity[0].user_assigned_identity_id, null)
}

# ============================================================================
# NODE RESOURCE GROUP
# ============================================================================

output "node_resource_group" {
  description = "The auto-generated resource group for cluster nodes"
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

output "node_resource_group_id" {
  description = "The ID of the node resource group"
  value       = azurerm_kubernetes_cluster.this.node_resource_group_id
}

# ============================================================================
# NETWORK OUTPUTS
# ============================================================================

output "network_profile" {
  description = "The network profile configuration"
  value       = azurerm_kubernetes_cluster.this.network_profile
}

output "network_plugin" {
  description = "The network plugin used by the cluster"
  value       = try(azurerm_kubernetes_cluster.this.network_profile[0].network_plugin, null)
}

output "service_cidr" {
  description = "The service CIDR used by the cluster"
  value       = try(azurerm_kubernetes_cluster.this.network_profile[0].service_cidr, null)
}

output "dns_service_ip" {
  description = "The DNS service IP used by the cluster"
  value       = try(azurerm_kubernetes_cluster.this.network_profile[0].dns_service_ip, null)
}

output "pod_cidr" {
  description = "The pod CIDR used by the cluster"
  value       = try(azurerm_kubernetes_cluster.this.network_profile[0].pod_cidr, null)
}

# ============================================================================
# OIDC AND WORKLOAD IDENTITY
# ============================================================================

output "oidc_issuer_url" {
  description = "The OIDC issuer URL for the cluster (used for workload identity)"
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

# ============================================================================
# KEY VAULT SECRETS PROVIDER
# ============================================================================

output "key_vault_secrets_provider" {
  description = "The Key Vault Secrets Provider configuration"
  value       = azurerm_kubernetes_cluster.this.key_vault_secrets_provider
}

output "key_vault_secrets_provider_identity" {
  description = "The identity used by Key Vault Secrets Provider"
  value       = try(azurerm_kubernetes_cluster.this.key_vault_secrets_provider[0].secret_identity, null)
}

# ============================================================================
# OMS AGENT
# ============================================================================

output "oms_agent" {
  description = "The OMS Agent configuration"
  value       = azurerm_kubernetes_cluster.this.oms_agent
}

output "oms_agent_identity" {
  description = "The identity used by OMS Agent"
  value       = try(azurerm_kubernetes_cluster.this.oms_agent[0].oms_agent_identity, null)
}

# ============================================================================
# INGRESS APPLICATION GATEWAY
# ============================================================================

output "ingress_application_gateway" {
  description = "The Ingress Application Gateway configuration"
  value       = azurerm_kubernetes_cluster.this.ingress_application_gateway
}

output "ingress_application_gateway_identity" {
  description = "The identity used by Ingress Application Gateway"
  value       = try(azurerm_kubernetes_cluster.this.ingress_application_gateway[0].ingress_application_gateway_identity, null)
}

# ============================================================================
# WEB APP ROUTING
# ============================================================================

output "web_app_routing_identity" {
  description = "The identity used by Web App Routing"
  value       = try(azurerm_kubernetes_cluster.this.web_app_routing[0].web_app_routing_identity, null)
}

# ============================================================================
# HTTP APPLICATION ROUTING
# ============================================================================

output "http_application_routing_zone_name" {
  description = "The zone name for HTTP application routing (deprecated)"
  value       = azurerm_kubernetes_cluster.this.http_application_routing_zone_name
}

# ============================================================================
# CURRENT KUBERNETES VERSION
# ============================================================================

output "current_kubernetes_version" {
  description = "The current Kubernetes version running on the cluster"
  value       = azurerm_kubernetes_cluster.this.current_kubernetes_version
}

# ============================================================================
# PRIVATE CLUSTER DETAILS
# ============================================================================

output "private_cluster_enabled" {
  description = "Whether the cluster is a private cluster"
  value       = azurerm_kubernetes_cluster.this.private_cluster_enabled
}

output "private_cluster_public_fqdn_enabled" {
  description = "Whether public FQDN is enabled for the private cluster"
  value       = azurerm_kubernetes_cluster.this.private_cluster_public_fqdn_enabled
}

# ============================================================================
# AZURE AD RBAC
# ============================================================================

output "azure_ad_rbac_enabled" {
  description = "Whether Azure AD RBAC is enabled"
  value       = try(azurerm_kubernetes_cluster.this.azure_active_directory_role_based_access_control[0].azure_rbac_enabled, null)
}

output "azure_ad_rbac_tenant_id" {
  description = "The tenant ID for Azure AD RBAC"
  value       = try(azurerm_kubernetes_cluster.this.azure_active_directory_role_based_access_control[0].tenant_id, null)
}

# ============================================================================
# MICROSOFT DEFENDER
# ============================================================================

output "microsoft_defender_enabled" {
  description = "Whether Microsoft Defender is enabled"
  value       = var.microsoft_defender != null ? true : false
}

# ============================================================================
# STORAGE PROFILE
# ============================================================================

output "storage_profile" {
  description = "The storage profile configuration"
  value       = azurerm_kubernetes_cluster.this.storage_profile
}

# ============================================================================
# WORKLOAD IDENTITY
# ============================================================================

output "workload_identity_enabled" {
  description = "Whether workload identity is enabled"
  value       = azurerm_kubernetes_cluster.this.workload_identity_enabled
}

# ============================================================================
# ALL CLUSTER DETAILS (COMPLETE OBJECT)
# ============================================================================

output "cluster" {
  description = "The complete AKS cluster object with all attributes"
  value       = azurerm_kubernetes_cluster.this
  sensitive   = true
}
