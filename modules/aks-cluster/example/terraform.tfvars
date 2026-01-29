# ==============================================================================
# BASIC EXAMPLE - Minimal Configuration
# ==============================================================================
# This example shows the minimum required configuration to create an AKS cluster

cluster_name        = "example-aks"
location            = "East US"
resource_group_name = "example-rg"
dns_prefix          = "example-aks"

# ==============================================================================
# ADVANCED EXAMPLE - Production Configuration (Commented)
# ==============================================================================
# Uncomment and modify the sections below for production deployments

# ------------------------------------------------------------------------------
# Core Configuration
# ------------------------------------------------------------------------------
kubernetes_version = "1.27.0"
sku_tier           = "Standard" # Free, Standard, Premium
# automatic_channel_upgrade = "stable"    # patch, rapid, node-image, stable, none
# node_os_channel_upgrade   = "SecurityPatch"  # NodeImage, None, Unmanaged, SecurityPatch
# support_plan              = "KubernetesOfficial"  # AKSLongTermSupport

# ------------------------------------------------------------------------------
# Security & Compliance
# ------------------------------------------------------------------------------
# azure_policy_enabled      = true
# local_account_disabled    = true
# oidc_issuer_enabled       = true
# workload_identity_enabled = true
# image_cleaner_enabled     = true
# image_cleaner_interval_hours = 48
# cost_analysis_enabled     = true

# ------------------------------------------------------------------------------
# Private Cluster Configuration
# ------------------------------------------------------------------------------
# private_cluster_enabled = true
# private_dns_zone_id     = "System"  # or custom zone ID
# private_cluster_public_fqdn_enabled = false

# ------------------------------------------------------------------------------
# Default Node Pool
# ------------------------------------------------------------------------------
default_node_pool_name    = "default"
default_node_pool_vm_size = "Standard_D2_v2"
default_node_pool_count   = 3
enable_auto_scaling       = true
min_node_count            = 1
max_node_count            = 5

# default_node_pool_zones   = ["1", "2", "3"]
# default_node_pool_max_pods = 30
# default_node_pool_os_disk_size_gb = 128
# default_node_pool_os_disk_type    = "Managed"  # Managed, Ephemeral
# default_node_pool_os_sku          = "Ubuntu"   # Ubuntu, CBLMariner, AzureLinux

# default_node_pool_node_labels = {
#   role        = "system"
#   environment = "production"
# }

# default_node_pool_node_taints = [
#   "CriticalAddonsOnly=true:NoSchedule"
# ]

# default_node_pool_enable_host_encryption = true
# default_node_pool_enable_node_public_ip  = false
# default_node_pool_ultra_ssd_enabled      = false

# ------------------------------------------------------------------------------
# Identity Configuration
# ------------------------------------------------------------------------------
# identity_type = "SystemAssigned"  # or "UserAssigned"
# identity_ids  = ["/subscriptions/.../resourcegroups/.../providers/Microsoft.ManagedIdentity/userAssignedIdentities/..."]

# ------------------------------------------------------------------------------
# Network Profile
# ------------------------------------------------------------------------------
network_plugin    = "azure" # azure, kubenet, none
load_balancer_sku = "standard"

# network_policy      = "azure"  # azure, calico, cilium
# network_plugin_mode = "overlay"
# service_cidr        = "10.0.0.0/16"
# dns_service_ip      = "10.0.0.10"
# pod_cidr            = "10.244.0.0/16"  # For kubenet
# outbound_type       = "loadBalancer"   # loadBalancer, userDefinedRouting, managedNATGateway
# ip_versions         = ["IPv4"]         # ["IPv4", "IPv6"] for dual-stack

# ------------------------------------------------------------------------------
# Load Balancer Profile (for Standard SKU)
# ------------------------------------------------------------------------------
# load_balancer_profile = {
#   managed_outbound_ip_count   = 1
#   outbound_ports_allocated    = 0
#   idle_timeout_in_minutes     = 30
# }

# ------------------------------------------------------------------------------
# NAT Gateway Profile
# ------------------------------------------------------------------------------
# nat_gateway_profile = {
#   managed_outbound_ip_count = 1
#   idle_timeout_in_minutes   = 4
# }

# ------------------------------------------------------------------------------
# API Server Access Profile
# ------------------------------------------------------------------------------
# api_server_access_profile = {
#   authorized_ip_ranges = [
#     "203.0.113.0/24",
#     "198.51.100.0/24"
#   ]
#   # For private clusters with VNet integration:
#   # subnet_id                = "/subscriptions/.../subnets/aks-api"
#   # vnet_integration_enabled = true
# }

# ------------------------------------------------------------------------------
# Auto Scaler Profile
# ------------------------------------------------------------------------------
# auto_scaler_profile = {
#   balance_similar_node_groups      = true
#   expander                         = "least-waste"  # least-waste, most-pods, priority, random
#   max_graceful_termination_sec     = 600
#   max_node_provisioning_time       = "15m"
#   max_unready_nodes                = 3
#   max_unready_percentage           = 45
#   new_pod_scale_up_delay           = "0s"
#   scale_down_delay_after_add       = "10m"
#   scale_down_delay_after_delete    = "10s"
#   scale_down_delay_after_failure   = "3m"
#   scan_interval                    = "10s"
#   scale_down_unneeded              = "10m"
#   scale_down_unready               = "20m"
#   scale_down_utilization_threshold = 0.5
#   skip_nodes_with_local_storage    = false
#   skip_nodes_with_system_pods      = true
# }

# ------------------------------------------------------------------------------
# Azure Active Directory RBAC
# ------------------------------------------------------------------------------
# azure_active_directory_role_based_access_control = {
#   managed            = true
#   azure_rbac_enabled = true
#   admin_group_object_ids = [
#     "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#   ]
# }

# ------------------------------------------------------------------------------
# HTTP Proxy Configuration
# ------------------------------------------------------------------------------
# http_proxy_config = {
#   http_proxy  = "http://proxy.example.com:8080"
#   https_proxy = "http://proxy.example.com:8443"
#   no_proxy = [
#     "localhost",
#     "127.0.0.1",
#     ".svc.cluster.local"
#   ]
#   # trusted_ca = filebase64("ca-bundle.crt")
# }

# ------------------------------------------------------------------------------
# Key Vault Secrets Provider
# ------------------------------------------------------------------------------
# key_vault_secrets_provider = {
#   secret_rotation_enabled  = true
#   secret_rotation_interval = "2m"
# }

# ------------------------------------------------------------------------------
# Linux Profile (for SSH access)
# ------------------------------------------------------------------------------
# linux_profile = {
#   admin_username = "azureuser"
#   ssh_key = {
#     key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."
#   }
# }

# ------------------------------------------------------------------------------
# Windows Profile (required for Windows node pools)
# ------------------------------------------------------------------------------
# windows_profile = {
#   admin_username = "azureuser"
#   # admin_password = "P@ssw0rd1234!"  # Use from variables or secrets
#   license        = "Windows_Server"
# }

# ------------------------------------------------------------------------------
# Maintenance Windows
# ------------------------------------------------------------------------------
# maintenance_window_auto_upgrade = {
#   frequency   = "Weekly"
#   interval    = 1
#   duration    = 4
#   day_of_week = 0  # Sunday
#   start_time  = "00:00"
#   utc_offset  = "+00:00"
#   
#   not_allowed = [{
#     start = "2024-12-20T00:00:00Z"
#     end   = "2024-12-27T00:00:00Z"
#   }]
# }

# maintenance_window_node_os = {
#   frequency   = "Daily"
#   interval    = 1
#   duration    = 4
#   start_time  = "02:00"
#   utc_offset  = "+00:00"
# }

# ------------------------------------------------------------------------------
# Microsoft Defender
# ------------------------------------------------------------------------------
# microsoft_defender = {
#   log_analytics_workspace_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.OperationalInsights/workspaces/my-workspace"
# }

# ------------------------------------------------------------------------------
# OMS Agent (Azure Monitor)
# ------------------------------------------------------------------------------
# oms_agent = {
#   log_analytics_workspace_id      = "/subscriptions/.../resourceGroups/.../providers/Microsoft.OperationalInsights/workspaces/my-workspace"
#   msi_auth_for_monitoring_enabled = true
# }

# ------------------------------------------------------------------------------
# Monitor Metrics
# ------------------------------------------------------------------------------
# monitor_metrics = {
#   annotations_allowed = "prometheus.io/scrape,prometheus.io/port"
#   labels_allowed      = "app,component,environment"
# }

# ------------------------------------------------------------------------------
# Service Mesh Profile (Istio)
# ------------------------------------------------------------------------------
# service_mesh_profile = {
#   mode                             = "Istio"
#   internal_ingress_gateway_enabled = true
#   external_ingress_gateway_enabled = true
# }

# ------------------------------------------------------------------------------
# Storage Profile
# ------------------------------------------------------------------------------
# storage_profile = {
#   blob_driver_enabled         = true
#   disk_driver_enabled         = true
#   disk_driver_version         = "v2"
#   file_driver_enabled         = true
#   snapshot_controller_enabled = true
# }

# ------------------------------------------------------------------------------
# Web App Routing
# ------------------------------------------------------------------------------
# web_app_routing = {
#   dns_zone_ids = [
#     "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/dnszones/example.com"
#   ]
# }

# ------------------------------------------------------------------------------
# Workload Autoscaler Profile
# ------------------------------------------------------------------------------
# workload_autoscaler_profile = {
#   keda_enabled                    = true
#   vertical_pod_autoscaler_enabled = false
# }

# ------------------------------------------------------------------------------
# Tags
# ------------------------------------------------------------------------------
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}

