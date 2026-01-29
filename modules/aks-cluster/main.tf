resource "azurerm_kubernetes_cluster" "this" {
  # ============================================================================
  # REQUIRED ATTRIBUTES
  # ============================================================================
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # ============================================================================
  # CORE CONFIGURATION
  # ============================================================================
  dns_prefix                          = var.dns_prefix
  dns_prefix_private_cluster          = var.dns_prefix_private_cluster
  kubernetes_version                  = var.kubernetes_version
  sku_tier                            = var.sku_tier
  node_resource_group                 = var.node_resource_group
  automatic_upgrade_channel           = var.automatic_channel_upgrade
  node_os_upgrade_channel             = var.node_os_channel_upgrade
  azure_policy_enabled                = var.azure_policy_enabled
  disk_encryption_set_id              = var.disk_encryption_set_id
  edge_zone                           = var.edge_zone
  http_application_routing_enabled    = var.http_application_routing_enabled
  image_cleaner_enabled               = var.image_cleaner_enabled
  image_cleaner_interval_hours        = var.image_cleaner_enabled ? var.image_cleaner_interval_hours : null
  local_account_disabled              = var.local_account_disabled
  oidc_issuer_enabled                 = var.oidc_issuer_enabled
  open_service_mesh_enabled           = var.open_service_mesh_enabled
  private_cluster_enabled             = var.private_cluster_enabled
  private_dns_zone_id                 = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  run_command_enabled                 = var.run_command_enabled
  workload_identity_enabled           = var.workload_identity_enabled
  support_plan                        = var.support_plan
  cost_analysis_enabled               = var.cost_analysis_enabled
  tags                                = var.tags

  # ============================================================================
  # DEFAULT NODE POOL
  # ============================================================================
  default_node_pool {
    name                         = var.default_node_pool_name
    vm_size                      = var.default_node_pool_vm_size
    auto_scaling_enabled         = var.enable_auto_scaling
    node_count                   = var.enable_auto_scaling ? null : var.default_node_pool_count
    min_count                    = var.enable_auto_scaling ? var.min_node_count : null
    max_count                    = var.enable_auto_scaling ? var.max_node_count : null
    zones                        = var.default_node_pool_zones
    host_encryption_enabled      = var.default_node_pool_enable_host_encryption
    node_public_ip_enabled       = var.default_node_pool_enable_node_public_ip
    max_pods                     = var.default_node_pool_max_pods
    node_labels                  = var.default_node_pool_node_labels
    only_critical_addons_enabled = length(var.default_node_pool_node_taints) > 0 ? contains(var.default_node_pool_node_taints, "CriticalAddonsOnly=true:NoSchedule") : null
    os_disk_size_gb              = var.default_node_pool_os_disk_size_gb
    os_disk_type                 = var.default_node_pool_os_disk_type
    os_sku                       = var.default_node_pool_os_sku
    vnet_subnet_id               = var.default_node_pool_vnet_subnet_id
    pod_subnet_id                = var.default_node_pool_pod_subnet_id
    ultra_ssd_enabled            = var.default_node_pool_ultra_ssd_enabled

    dynamic "upgrade_settings" {
      for_each = var.default_node_pool_upgrade_settings != null ? [var.default_node_pool_upgrade_settings] : []
      content {
        max_surge = upgrade_settings.value.max_surge
      }
    }
  }

  # ============================================================================
  # IDENTITY
  # ============================================================================
  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : null
  }

  # ============================================================================
  # NETWORK PROFILE
  # ============================================================================
  network_profile {
    network_plugin      = var.network_plugin
    network_mode        = var.network_mode
    network_policy      = var.network_policy
    network_plugin_mode = var.network_plugin_mode
    dns_service_ip      = var.dns_service_ip
    service_cidr        = var.service_cidr
    service_cidrs       = var.service_cidrs
    pod_cidr            = var.pod_cidr
    pod_cidrs           = var.pod_cidrs
    ip_versions         = var.ip_versions
    outbound_type       = var.outbound_type
    load_balancer_sku   = var.load_balancer_sku
    network_data_plane  = var.network_data_plane

    dynamic "load_balancer_profile" {
      for_each = var.load_balancer_profile != null ? [var.load_balancer_profile] : []
      content {
        managed_outbound_ip_count   = load_balancer_profile.value.managed_outbound_ip_count
        managed_outbound_ipv6_count = load_balancer_profile.value.managed_outbound_ipv6_count
        outbound_ip_address_ids     = load_balancer_profile.value.outbound_ip_address_ids
        outbound_ip_prefix_ids      = load_balancer_profile.value.outbound_ip_prefix_ids
        outbound_ports_allocated    = load_balancer_profile.value.outbound_ports_allocated
        idle_timeout_in_minutes     = load_balancer_profile.value.idle_timeout_in_minutes
      }
    }

    dynamic "nat_gateway_profile" {
      for_each = var.nat_gateway_profile != null ? [var.nat_gateway_profile] : []
      content {
        managed_outbound_ip_count = nat_gateway_profile.value.managed_outbound_ip_count
        idle_timeout_in_minutes   = nat_gateway_profile.value.idle_timeout_in_minutes
      }
    }
  }

  # ============================================================================
  # API SERVER ACCESS PROFILE
  # ============================================================================
  dynamic "api_server_access_profile" {
    for_each = var.api_server_access_profile != null ? [var.api_server_access_profile] : []
    content {
      authorized_ip_ranges = api_server_access_profile.value.authorized_ip_ranges
      subnet_id            = api_server_access_profile.value.subnet_id
    }
  }

  # ============================================================================
  # AUTO SCALER PROFILE
  # ============================================================================
  dynamic "auto_scaler_profile" {
    for_each = var.auto_scaler_profile != null ? [var.auto_scaler_profile] : []
    content {
      balance_similar_node_groups      = auto_scaler_profile.value.balance_similar_node_groups
      expander                         = auto_scaler_profile.value.expander
      max_graceful_termination_sec     = auto_scaler_profile.value.max_graceful_termination_sec
      max_node_provisioning_time       = auto_scaler_profile.value.max_node_provisioning_time
      max_unready_nodes                = auto_scaler_profile.value.max_unready_nodes
      max_unready_percentage           = auto_scaler_profile.value.max_unready_percentage
      new_pod_scale_up_delay           = auto_scaler_profile.value.new_pod_scale_up_delay
      scale_down_delay_after_add       = auto_scaler_profile.value.scale_down_delay_after_add
      scale_down_delay_after_delete    = auto_scaler_profile.value.scale_down_delay_after_delete
      scale_down_delay_after_failure   = auto_scaler_profile.value.scale_down_delay_after_failure
      scan_interval                    = auto_scaler_profile.value.scan_interval
      scale_down_unneeded              = auto_scaler_profile.value.scale_down_unneeded
      scale_down_unready               = auto_scaler_profile.value.scale_down_unready
      scale_down_utilization_threshold = auto_scaler_profile.value.scale_down_utilization_threshold
      empty_bulk_delete_max            = auto_scaler_profile.value.empty_bulk_delete_max
      skip_nodes_with_local_storage    = auto_scaler_profile.value.skip_nodes_with_local_storage
      skip_nodes_with_system_pods      = auto_scaler_profile.value.skip_nodes_with_system_pods
    }
  }

  # ============================================================================
  # AZURE ACTIVE DIRECTORY RBAC
  # ============================================================================
  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.azure_active_directory_role_based_access_control != null ? [var.azure_active_directory_role_based_access_control] : []
    content {
      tenant_id              = azure_active_directory_role_based_access_control.value.tenant_id
      admin_group_object_ids = azure_active_directory_role_based_access_control.value.admin_group_object_ids
      azure_rbac_enabled     = azure_active_directory_role_based_access_control.value.azure_rbac_enabled
    }
  }

  # ============================================================================
  # HTTP PROXY CONFIG
  # ============================================================================
  dynamic "http_proxy_config" {
    for_each = var.http_proxy_config != null ? [var.http_proxy_config] : []
    content {
      http_proxy  = http_proxy_config.value.http_proxy
      https_proxy = http_proxy_config.value.https_proxy
      no_proxy    = http_proxy_config.value.no_proxy
      trusted_ca  = http_proxy_config.value.trusted_ca
    }
  }

  # ============================================================================
  # KEY MANAGEMENT SERVICE
  # ============================================================================
  dynamic "key_management_service" {
    for_each = var.key_management_service != null ? [var.key_management_service] : []
    content {
      key_vault_key_id         = key_management_service.value.key_vault_key_id
      key_vault_network_access = key_management_service.value.key_vault_network_access
    }
  }

  # ============================================================================
  # KEY VAULT SECRETS PROVIDER
  # ============================================================================
  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider != null ? [var.key_vault_secrets_provider] : []
    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  # ============================================================================
  # KUBELET IDENTITY
  # ============================================================================
  dynamic "kubelet_identity" {
    for_each = var.kubelet_identity != null ? [var.kubelet_identity] : []
    content {
      client_id                 = kubelet_identity.value.client_id
      object_id                 = kubelet_identity.value.object_id
      user_assigned_identity_id = kubelet_identity.value.user_assigned_identity_id
    }
  }

  # ============================================================================
  # LINUX PROFILE
  # ============================================================================
  dynamic "linux_profile" {
    for_each = var.linux_profile != null ? [var.linux_profile] : []
    content {
      admin_username = linux_profile.value.admin_username

      ssh_key {
        key_data = linux_profile.value.ssh_key.key_data
      }
    }
  }

  # ============================================================================
  # MAINTENANCE WINDOW
  # ============================================================================
  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [var.maintenance_window] : []
    content {
      dynamic "allowed" {
        for_each = maintenance_window.value.allowed != null ? maintenance_window.value.allowed : []
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }

      dynamic "not_allowed" {
        for_each = maintenance_window.value.not_allowed != null ? maintenance_window.value.not_allowed : []
        content {
          start = not_allowed.value.start
          end   = not_allowed.value.end
        }
      }
    }
  }

  # ============================================================================
  # MAINTENANCE WINDOW AUTO UPGRADE
  # ============================================================================
  dynamic "maintenance_window_auto_upgrade" {
    for_each = var.maintenance_window_auto_upgrade != null ? [var.maintenance_window_auto_upgrade] : []
    content {
      frequency    = maintenance_window_auto_upgrade.value.frequency
      interval     = maintenance_window_auto_upgrade.value.interval
      duration     = maintenance_window_auto_upgrade.value.duration
      day_of_week  = maintenance_window_auto_upgrade.value.day_of_week
      day_of_month = maintenance_window_auto_upgrade.value.day_of_month
      week_index   = maintenance_window_auto_upgrade.value.week_index
      start_time   = maintenance_window_auto_upgrade.value.start_time
      utc_offset   = maintenance_window_auto_upgrade.value.utc_offset
      start_date   = maintenance_window_auto_upgrade.value.start_date

      dynamic "not_allowed" {
        for_each = maintenance_window_auto_upgrade.value.not_allowed != null ? maintenance_window_auto_upgrade.value.not_allowed : []
        content {
          start = not_allowed.value.start
          end   = not_allowed.value.end
        }
      }
    }
  }

  # ============================================================================
  # MAINTENANCE WINDOW NODE OS
  # ============================================================================
  dynamic "maintenance_window_node_os" {
    for_each = var.maintenance_window_node_os != null ? [var.maintenance_window_node_os] : []
    content {
      frequency    = maintenance_window_node_os.value.frequency
      interval     = maintenance_window_node_os.value.interval
      duration     = maintenance_window_node_os.value.duration
      day_of_week  = maintenance_window_node_os.value.day_of_week
      day_of_month = maintenance_window_node_os.value.day_of_month
      week_index   = maintenance_window_node_os.value.week_index
      start_time   = maintenance_window_node_os.value.start_time
      utc_offset   = maintenance_window_node_os.value.utc_offset
      start_date   = maintenance_window_node_os.value.start_date

      dynamic "not_allowed" {
        for_each = maintenance_window_node_os.value.not_allowed != null ? maintenance_window_node_os.value.not_allowed : []
        content {
          start = not_allowed.value.start
          end   = not_allowed.value.end
        }
      }
    }
  }

  # ============================================================================
  # MICROSOFT DEFENDER
  # ============================================================================
  dynamic "microsoft_defender" {
    for_each = var.microsoft_defender != null ? [var.microsoft_defender] : []
    content {
      log_analytics_workspace_id = microsoft_defender.value.log_analytics_workspace_id
    }
  }

  # ============================================================================
  # MONITOR METRICS
  # ============================================================================
  dynamic "monitor_metrics" {
    for_each = var.monitor_metrics != null ? [var.monitor_metrics] : []
    content {
      annotations_allowed = monitor_metrics.value.annotations_allowed
      labels_allowed      = monitor_metrics.value.labels_allowed
    }
  }

  # ============================================================================
  # OMS AGENT
  # ============================================================================
  dynamic "oms_agent" {
    for_each = var.oms_agent != null ? [var.oms_agent] : []
    content {
      log_analytics_workspace_id      = oms_agent.value.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = oms_agent.value.msi_auth_for_monitoring_enabled
    }
  }

  # ============================================================================
  # SERVICE MESH PROFILE
  # ============================================================================
  dynamic "service_mesh_profile" {
    for_each = var.service_mesh_profile != null ? [var.service_mesh_profile] : []
    content {
      mode                             = service_mesh_profile.value.mode
      internal_ingress_gateway_enabled = service_mesh_profile.value.internal_ingress_gateway_enabled
      external_ingress_gateway_enabled = service_mesh_profile.value.external_ingress_gateway_enabled

      revisions = []
    }
  }

  # ============================================================================
  # STORAGE PROFILE
  # ============================================================================
  dynamic "storage_profile" {
    for_each = var.storage_profile != null ? [var.storage_profile] : []
    content {
      blob_driver_enabled         = storage_profile.value.blob_driver_enabled
      disk_driver_enabled         = storage_profile.value.disk_driver_enabled
      file_driver_enabled         = storage_profile.value.file_driver_enabled
      snapshot_controller_enabled = storage_profile.value.snapshot_controller_enabled
    }
  }

  # ============================================================================
  # WEB APP ROUTING
  # ============================================================================
  dynamic "web_app_routing" {
    for_each = var.web_app_routing != null ? [var.web_app_routing] : []
    content {
      dns_zone_ids = web_app_routing.value.dns_zone_ids
    }
  }

  # ============================================================================
  # WINDOWS PROFILE
  # ============================================================================
  dynamic "windows_profile" {
    for_each = var.windows_profile != null ? [var.windows_profile] : []
    content {
      admin_username = windows_profile.value.admin_username
      admin_password = windows_profile.value.admin_password
      license        = windows_profile.value.license

      dynamic "gmsa" {
        for_each = windows_profile.value.gmsa != null ? [windows_profile.value.gmsa] : []
        content {
          dns_server  = gmsa.value.dns_server
          root_domain = gmsa.value.root_domain
        }
      }
    }
  }

  # ============================================================================
  # WORKLOAD AUTOSCALER PROFILE
  # ============================================================================
  dynamic "workload_autoscaler_profile" {
    for_each = var.workload_autoscaler_profile != null ? [var.workload_autoscaler_profile] : []
    content {
      keda_enabled                    = workload_autoscaler_profile.value.keda_enabled
      vertical_pod_autoscaler_enabled = workload_autoscaler_profile.value.vertical_pod_autoscaler_enabled
    }
  }

  # ============================================================================
  # CONFIDENTIAL COMPUTING
  # ============================================================================
  dynamic "confidential_computing" {
    for_each = var.confidential_computing != null ? [var.confidential_computing] : []
    content {
      sgx_quote_helper_enabled = confidential_computing.value.sgx_quote_helper_enabled
    }
  }
}
