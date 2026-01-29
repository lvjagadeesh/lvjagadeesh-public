aks_clusters = {
  # ==============================================================================
  # DEVELOPMENT CLUSTER - Basic Configuration
  # ==============================================================================
  dev = {
    cluster_name        = "aks-dev-eastus"
    location            = "East US"
    resource_group_name = "rg-aks-dev"
    dns_prefix          = "aks-dev"

    # Core Configuration
    kubernetes_version = "1.27.0"
    sku_tier           = "Free"
    
    # Security
    azure_policy_enabled      = false
    oidc_issuer_enabled       = true
    workload_identity_enabled = true
    
    # Default Node Pool
    default_node_pool_name    = "system"
    default_node_pool_vm_size = "Standard_D2_v2"
    enable_auto_scaling       = true
    min_node_count            = 1
    max_node_count            = 3
    default_node_pool_max_pods = 30
    default_node_pool_os_sku   = "Ubuntu"
    
    default_node_pool_node_labels = {
      role        = "system"
      environment = "development"
    }

    # Network Configuration
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "10.0.0.0/16"
    dns_service_ip    = "10.0.0.10"
    outbound_type     = "loadBalancer"
    
    # Tags
    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
      CostCenter  = "Engineering"
      Project     = "AKS-Dev"
    }
  }

  # ==============================================================================
  # PRODUCTION CLUSTER - Advanced Configuration
  # ==============================================================================
  prod = {
    cluster_name        = "aks-prod-westus"
    location            = "West US"
    resource_group_name = "rg-aks-prod"
    dns_prefix          = "aks-prod"

    # Core Configuration
    kubernetes_version        = "1.28.0"
    sku_tier                  = "Standard"
    automatic_channel_upgrade = "stable"
    node_os_channel_upgrade   = "SecurityPatch"
    support_plan              = "KubernetesOfficial"
    
    # Security & Compliance
    azure_policy_enabled      = true
    local_account_disabled    = true
    oidc_issuer_enabled       = true
    workload_identity_enabled = true
    image_cleaner_enabled     = true
    image_cleaner_interval_hours = 48
    cost_analysis_enabled     = true
    
    # Default Node Pool - Production
    default_node_pool_name    = "system"
    default_node_pool_vm_size = "Standard_D4_v3"
    enable_auto_scaling       = true
    min_node_count            = 3
    max_node_count            = 10
    default_node_pool_zones   = ["1", "2", "3"]
    default_node_pool_max_pods = 50
    default_node_pool_os_disk_size_gb = 256
    default_node_pool_os_disk_type    = "Managed"
    default_node_pool_os_sku          = "Ubuntu"
    default_node_pool_enable_host_encryption = true
    
    default_node_pool_node_labels = {
      role        = "system"
      environment = "production"
      tier        = "critical"
    }
    
    default_node_pool_node_taints = [
      "CriticalAddonsOnly=true:NoSchedule"
    ]
    
    default_node_pool_upgrade_settings = {
      max_surge = "33%"
    }

    # Network Configuration - Production
    network_plugin      = "azure"
    network_policy      = "azure"
    load_balancer_sku   = "standard"
    service_cidr        = "10.1.0.0/16"
    dns_service_ip      = "10.1.0.10"
    outbound_type       = "loadBalancer"
    network_data_plane  = "azure"
    
    load_balancer_profile = {
      managed_outbound_ip_count = 2
      outbound_ports_allocated  = 0
      idle_timeout_in_minutes   = 30
    }
    
    # Auto Scaler Profile
    auto_scaler_profile = {
      balance_similar_node_groups      = true
      expander                         = "least-waste"
      max_graceful_termination_sec     = 600
      max_node_provisioning_time       = "15m"
      scale_down_delay_after_add       = "10m"
      scale_down_unneeded              = "10m"
      scale_down_utilization_threshold = 0.5
      skip_nodes_with_system_pods      = true
    }
    
    # Maintenance Windows
    maintenance_window_auto_upgrade = {
      frequency   = "Weekly"
      interval    = 1
      duration    = 4
      day_of_week = 0  # Sunday
      start_time  = "00:00"
      utc_offset  = "+00:00"
    }
    
    maintenance_window_node_os = {
      frequency   = "Daily"
      interval    = 1
      duration    = 4
      start_time  = "02:00"
      utc_offset  = "+00:00"
    }
    
    # Tags
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      CostCenter  = "Operations"
      Project     = "AKS-Prod"
      Criticality = "High"
      Compliance  = "Required"
    }
  }
}
