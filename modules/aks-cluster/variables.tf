variable "aks_clusters" {
  description = "(Required) Map of AKS clusters to create"
  type = map(object({
    # ============================================================================
    # REQUIRED ATTRIBUTES
    # ============================================================================
    cluster_name               = string           # (Required) Name of the AKS cluster
    location                   = string           # (Required) Azure region where the AKS cluster will be created
    resource_group_name        = string           # (Required) Name of the resource group
    dns_prefix                 = optional(string) # (Optional) DNS prefix for the AKS cluster
    dns_prefix_private_cluster = optional(string) # (Optional) DNS prefix for private clusters

    # ============================================================================
    # CORE CONFIGURATION
    # ============================================================================
    kubernetes_version                  = optional(string) # (Optional) Kubernetes version (e.g., 1.27.0, 1.28.0)
    sku_tier                            = optional(string) # (Optional) SKU Tier: Free, Standard, Premium
    node_resource_group                 = optional(string) # (Optional) Name of the resource group for cluster nodes
    automatic_channel_upgrade           = optional(string) # (Optional) Upgrade channel: patch, rapid, node-image, stable, none
    node_os_channel_upgrade             = optional(string) # (Optional) OS upgrade channel: NodeImage, None, Unmanaged, SecurityPatch
    azure_policy_enabled                = optional(bool)   # (Optional) Enable Azure Policy for Kubernetes
    disk_encryption_set_id              = optional(string) # (Optional) ID of the Disk Encryption Set
    edge_zone                           = optional(string) # (Optional) Edge Zone within the Azure Region
    http_application_routing_enabled    = optional(bool)   # (Optional) Enable HTTP Application Routing
    image_cleaner_enabled               = optional(bool)   # (Optional) Enable Image Cleaner
    image_cleaner_interval_hours        = optional(number) # (Optional) Interval in hours for Image Cleaner
    local_account_disabled              = optional(bool)   # (Optional) Disable local Kubernetes accounts
    oidc_issuer_enabled                 = optional(bool)   # (Optional) Enable OIDC Issuer
    open_service_mesh_enabled           = optional(bool)   # (Optional) Enable Open Service Mesh
    private_cluster_enabled             = optional(bool)   # (Optional) Enable private cluster
    private_dns_zone_id                 = optional(string) # (Optional) Private DNS Zone ID
    private_cluster_public_fqdn_enabled = optional(bool)   # (Optional) Enable public FQDN for private cluster
    run_command_enabled                 = optional(bool)   # (Optional) Enable Run Command feature
    workload_identity_enabled           = optional(bool)   # (Optional) Enable Workload Identity
    support_plan                        = optional(string) # (Optional) Support plan: KubernetesOfficial, AKSLongTermSupport
    cost_analysis_enabled               = optional(bool)   # (Optional) Enable cost analysis

    # ============================================================================
    # DEFAULT NODE POOL
    # ============================================================================
    default_node_pool_name                   = optional(string)       # (Optional) Name of the default node pool
    default_node_pool_vm_size                = optional(string)       # (Optional) VM size for nodes
    default_node_pool_count                  = optional(number)       # (Optional) Initial number of nodes
    enable_auto_scaling                      = optional(bool)         # (Optional) Enable auto-scaling
    min_node_count                           = optional(number)       # (Optional) Minimum node count for auto-scaling
    max_node_count                           = optional(number)       # (Optional) Maximum node count for auto-scaling
    default_node_pool_zones                  = optional(list(string)) # (Optional) Availability zones
    default_node_pool_enable_host_encryption = optional(bool)         # (Optional) Enable host encryption
    default_node_pool_enable_node_public_ip  = optional(bool)         # (Optional) Enable public IP on nodes
    default_node_pool_max_pods               = optional(number)       # (Optional) Maximum pods per node
    default_node_pool_node_labels            = optional(map(string))  # (Optional) Labels for nodes
    default_node_pool_node_taints            = optional(list(string)) # (Optional) Taints for nodes
    default_node_pool_os_disk_size_gb        = optional(number)       # (Optional) OS disk size in GB
    default_node_pool_os_disk_type           = optional(string)       # (Optional) OS disk type: Managed, Ephemeral
    default_node_pool_os_sku                 = optional(string)       # (Optional) OS SKU: Ubuntu, CBLMariner, AzureLinux, Windows2019, Windows2022
    default_node_pool_vnet_subnet_id         = optional(string)       # (Optional) VNet subnet ID
    default_node_pool_pod_subnet_id          = optional(string)       # (Optional) Subnet ID for pods
    default_node_pool_ultra_ssd_enabled      = optional(bool)         # (Optional) Enable Ultra SSD
    default_node_pool_upgrade_settings = optional(object({            # (Optional) Upgrade settings
      max_surge = string
    }))

    # ============================================================================
    # NETWORK PROFILE
    # ============================================================================
    network_plugin      = optional(string)       # (Optional) Network plugin: azure, kubenet, none
    network_mode        = optional(string)       # (Optional) Network mode: transparent, bridge
    network_policy      = optional(string)       # (Optional) Network policy: azure, calico, cilium
    network_plugin_mode = optional(string)       # (Optional) Network plugin mode: overlay
    dns_service_ip      = optional(string)       # (Optional) IP address for Kubernetes DNS service
    service_cidr        = optional(string)       # (Optional) CIDR for Kubernetes services
    service_cidrs       = optional(list(string)) # (Optional) List of service CIDRs for dual-stack
    pod_cidr            = optional(string)       # (Optional) CIDR for Kubernetes pods
    pod_cidrs           = optional(list(string)) # (Optional) List of pod CIDRs for dual-stack
    ip_versions         = optional(list(string)) # (Optional) IP versions: IPv4, IPv6
    outbound_type       = optional(string)       # (Optional) Outbound routing method
    load_balancer_sku   = optional(string)       # (Optional) Load balancer SKU: basic, standard
    load_balancer_profile = optional(object({    # (Optional) Load balancer profile configuration
      managed_outbound_ip_count   = optional(number)
      managed_outbound_ipv6_count = optional(number)
      outbound_ip_address_ids     = optional(list(string))
      outbound_ip_prefix_ids      = optional(list(string))
      outbound_ports_allocated    = optional(number)
      idle_timeout_in_minutes     = optional(number)
    }))
    nat_gateway_profile = optional(object({ # (Optional) NAT Gateway profile configuration
      managed_outbound_ip_count = optional(number)
      idle_timeout_in_minutes   = optional(number)
    }))
    network_data_plane = optional(string) # (Optional) Network data plane: azure, cilium

    # ============================================================================
    # API SERVER ACCESS PROFILE
    # ============================================================================
    api_server_access_profile = optional(object({
      authorized_ip_ranges = optional(list(string))
      subnet_id            = optional(string)
    }))

    # ============================================================================
    # AUTO SCALER PROFILE
    # ============================================================================
    auto_scaler_profile = optional(object({
      balance_similar_node_groups      = optional(bool)
      expander                         = optional(string)
      max_graceful_termination_sec     = optional(number)
      max_node_provisioning_time       = optional(string)
      max_unready_nodes                = optional(number)
      max_unready_percentage           = optional(number)
      new_pod_scale_up_delay           = optional(string)
      scale_down_delay_after_add       = optional(string)
      scale_down_delay_after_delete    = optional(string)
      scale_down_delay_after_failure   = optional(string)
      scan_interval                    = optional(string)
      scale_down_unneeded              = optional(string)
      scale_down_unready               = optional(string)
      scale_down_utilization_threshold = optional(number)
      empty_bulk_delete_max            = optional(number)
      skip_nodes_with_local_storage    = optional(bool)
      skip_nodes_with_system_pods      = optional(bool)
    }))

    # ============================================================================
    # AZURE ACTIVE DIRECTORY RBAC
    # ============================================================================
    azure_active_directory_role_based_access_control = optional(object({
      tenant_id              = optional(string)
      admin_group_object_ids = optional(list(string))
      azure_rbac_enabled     = optional(bool)
    }))

    # ============================================================================
    # HTTP PROXY CONFIG
    # ============================================================================
    http_proxy_config = optional(object({
      http_proxy  = optional(string)
      https_proxy = optional(string)
      no_proxy    = optional(list(string))
      trusted_ca  = optional(string)
    }))

    # ============================================================================
    # IDENTITY
    # ============================================================================
    identity_type = optional(string)       # (Optional) Identity type: SystemAssigned, UserAssigned
    identity_ids  = optional(list(string)) # (Optional) List of user-assigned identity IDs

    # ============================================================================
    # KEY MANAGEMENT SERVICE
    # ============================================================================
    key_management_service = optional(object({
      key_vault_key_id         = string
      key_vault_network_access = optional(string)
    }))

    # ============================================================================
    # KEY VAULT SECRETS PROVIDER
    # ============================================================================
    key_vault_secrets_provider = optional(object({
      secret_rotation_enabled  = optional(bool)
      secret_rotation_interval = optional(string)
    }))

    # ============================================================================
    # KUBELET IDENTITY
    # ============================================================================
    kubelet_identity = optional(object({
      client_id                 = optional(string)
      object_id                 = optional(string)
      user_assigned_identity_id = optional(string)
    }))

    # ============================================================================
    # LINUX PROFILE
    # ============================================================================
    linux_profile = optional(object({
      admin_username = string
      ssh_key = object({
        key_data = string
      })
    }))

    # ============================================================================
    # MAINTENANCE WINDOW
    # ============================================================================
    maintenance_window = optional(object({
      allowed = optional(list(object({
        day   = string
        hours = list(number)
      })))
      not_allowed = optional(list(object({
        start = string
        end   = string
      })))
    }))
    maintenance_window_auto_upgrade = optional(object({
      frequency    = string
      interval     = number
      duration     = number
      day_of_week  = optional(number)
      day_of_month = optional(number)
      week_index   = optional(string)
      start_time   = optional(string)
      utc_offset   = optional(string)
      start_date   = optional(string)
      not_allowed = optional(list(object({
        start = string
        end   = string
      })))
    }))
    maintenance_window_node_os = optional(object({
      frequency    = string
      interval     = number
      duration     = number
      day_of_week  = optional(number)
      day_of_month = optional(number)
      week_index   = optional(string)
      start_time   = optional(string)
      utc_offset   = optional(string)
      start_date   = optional(string)
      not_allowed = optional(list(object({
        start = string
        end   = string
      })))
    }))

    # ============================================================================
    # MICROSOFT DEFENDER
    # ============================================================================
    microsoft_defender = optional(object({
      log_analytics_workspace_id = string
    }))

    # ============================================================================
    # MONITOR METRICS
    # ============================================================================
    monitor_metrics = optional(object({
      annotations_allowed = optional(string)
      labels_allowed      = optional(string)
    }))

    # ============================================================================
    # OMS AGENT (AZURE MONITOR)
    # ============================================================================
    oms_agent = optional(object({
      log_analytics_workspace_id      = string
      msi_auth_for_monitoring_enabled = optional(bool)
    }))

    # ============================================================================
    # SERVICE MESH PROFILE
    # ============================================================================
    service_mesh_profile = optional(object({
      mode                             = string
      internal_ingress_gateway_enabled = optional(bool)
      external_ingress_gateway_enabled = optional(bool)
    }))

    # ============================================================================
    # STORAGE PROFILE
    # ============================================================================
    storage_profile = optional(object({
      blob_driver_enabled         = optional(bool)
      disk_driver_enabled         = optional(bool)
      file_driver_enabled         = optional(bool)
      snapshot_controller_enabled = optional(bool)
    }))

    # ============================================================================
    # WEB APP ROUTING
    # ============================================================================
    web_app_routing = optional(object({
      dns_zone_ids = list(string)
    }))

    # ============================================================================
    # WINDOWS PROFILE
    # ============================================================================
    windows_profile = optional(object({
      admin_username = string
      admin_password = optional(string)
      license        = optional(string)
      gmsa = optional(object({
        dns_server  = string
        root_domain = string
      }))
    }))

    # ============================================================================
    # WORKLOAD AUTOSCALER PROFILE
    # ============================================================================
    workload_autoscaler_profile = optional(object({
      keda_enabled                    = optional(bool)
      vertical_pod_autoscaler_enabled = optional(bool)
    }))

    # ============================================================================
    # CONFIDENTIAL COMPUTING
    # ============================================================================
    confidential_computing = optional(object({
      sgx_quote_helper_enabled = bool
    }))

    # ============================================================================
    # TAGS
    # ============================================================================
    tags = optional(map(string)) # (Optional) Tags to apply to the AKS cluster
  }))

  validation {
    condition     = alltrue([for k, v in var.aks_clusters : length(v.cluster_name) > 0 && length(v.cluster_name) <= 63])
    error_message = "Cluster name must be between 1 and 63 characters."
  }

  validation {
    condition     = alltrue([for k, v in var.aks_clusters : length(v.location) > 0])
    error_message = "Location must be specified for each cluster."
  }

  validation {
    condition     = alltrue([for k, v in var.aks_clusters : length(v.resource_group_name) > 0])
    error_message = "Resource group name must be specified for each cluster."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.kubernetes_version == null || can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", v.kubernetes_version))
    ])
    error_message = "Kubernetes version must be in semantic version format (e.g., 1.27.0)."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.sku_tier == null || contains(["Free", "Standard", "Premium"], v.sku_tier)
    ])
    error_message = "SKU Tier must be one of: Free, Standard, Premium."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.automatic_channel_upgrade == null || contains(["patch", "rapid", "node-image", "stable", "none"], v.automatic_channel_upgrade)
    ])
    error_message = "Automatic channel upgrade must be one of: patch, rapid, node-image, stable, none."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.node_os_channel_upgrade == null || contains(["NodeImage", "None", "Unmanaged", "SecurityPatch"], v.node_os_channel_upgrade)
    ])
    error_message = "Node OS channel upgrade must be one of: NodeImage, None, Unmanaged, SecurityPatch."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.image_cleaner_interval_hours == null || v.image_cleaner_interval_hours > 0
    ])
    error_message = "Image cleaner interval must be greater than 0."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.support_plan == null || contains(["KubernetesOfficial", "AKSLongTermSupport"], v.support_plan)
    ])
    error_message = "Support plan must be one of: KubernetesOfficial, AKSLongTermSupport."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.default_node_pool_name == null || can(regex("^[a-z0-9]{1,12}$", v.default_node_pool_name))
    ])
    error_message = "Node pool name must be 1-12 characters, lowercase alphanumeric only."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.default_node_pool_count == null || (v.default_node_pool_count >= 1 && v.default_node_pool_count <= 1000)
    ])
    error_message = "Node pool count must be between 1 and 1000."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.min_node_count == null || v.min_node_count >= 1
    ])
    error_message = "Minimum node count must be at least 1."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.max_node_count == null || (v.max_node_count >= 1 && v.max_node_count <= 1000)
    ])
    error_message = "Maximum node count must be between 1 and 1000."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.default_node_pool_max_pods == null || (v.default_node_pool_max_pods >= 10 && v.default_node_pool_max_pods <= 250)
    ])
    error_message = "Max pods must be between 10 and 250."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.default_node_pool_os_disk_size_gb == null || v.default_node_pool_os_disk_size_gb >= 30
    ])
    error_message = "OS disk size must be at least 30 GB."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.default_node_pool_os_disk_type == null || contains(["Managed", "Ephemeral"], v.default_node_pool_os_disk_type)
    ])
    error_message = "OS disk type must be Managed or Ephemeral."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.default_node_pool_os_sku == null || contains(["Ubuntu", "CBLMariner", "Windows2019", "Windows2022", "AzureLinux"], v.default_node_pool_os_sku)
    ])
    error_message = "OS SKU must be Ubuntu, CBLMariner, AzureLinux, Windows2019, or Windows2022."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.network_plugin == null || contains(["azure", "kubenet", "none"], v.network_plugin)
    ])
    error_message = "Network plugin must be one of: azure, kubenet, none."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.network_mode == null || contains(["transparent", "bridge"], v.network_mode)
    ])
    error_message = "Network mode must be transparent or bridge."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.network_policy == null || contains(["azure", "calico", "cilium"], v.network_policy)
    ])
    error_message = "Network policy must be azure, calico, or cilium."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.network_plugin_mode == null || v.network_plugin_mode == "overlay"
    ])
    error_message = "Network plugin mode must be overlay."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.dns_service_ip == null || can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", v.dns_service_ip))
    ])
    error_message = "DNS service IP must be a valid IPv4 address."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.service_cidr == null || can(cidrhost(v.service_cidr, 0))
    ])
    error_message = "Service CIDR must be a valid CIDR notation."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.pod_cidr == null || can(cidrhost(v.pod_cidr, 0))
    ])
    error_message = "Pod CIDR must be a valid CIDR notation."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.ip_versions == null || alltrue([for ver in v.ip_versions : contains(["IPv4", "IPv6"], ver)])
    ])
    error_message = "IP versions must be IPv4 and/or IPv6."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.outbound_type == null || contains(["loadBalancer", "userDefinedRouting", "managedNATGateway", "userAssignedNATGateway"], v.outbound_type)
    ])
    error_message = "Outbound type must be loadBalancer, userDefinedRouting, managedNATGateway, or userAssignedNATGateway."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.load_balancer_sku == null || contains(["basic", "standard"], v.load_balancer_sku)
    ])
    error_message = "Load balancer SKU must be either basic or standard."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.network_data_plane == null || contains(["azure", "cilium"], v.network_data_plane)
    ])
    error_message = "Network data plane must be azure or cilium."
  }

  validation {
    condition = alltrue([
      for k, v in var.aks_clusters :
      v.identity_type == null || contains(["SystemAssigned", "UserAssigned"], v.identity_type)
    ])
    error_message = "Identity type must be SystemAssigned or UserAssigned."
  }
}
