resource "azurerm_kubernetes_cluster" "this" {
  for_each = var.aks_clusters

  # ============================================================================
  # REQUIRED ATTRIBUTES
  # ============================================================================
  name                = each.value.cluster_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  # ============================================================================
  # CORE CONFIGURATION
  # ============================================================================
  dns_prefix                          = try(each.value.dns_prefix, null)
  dns_prefix_private_cluster          = try(each.value.dns_prefix_private_cluster, null)
  kubernetes_version                  = try(each.value.kubernetes_version, "1.27.0")
  sku_tier                            = try(each.value.sku_tier, "Free")
  node_resource_group                 = try(each.value.node_resource_group, null)
  automatic_upgrade_channel           = try(each.value.automatic_channel_upgrade, null)
  node_os_upgrade_channel             = try(each.value.node_os_channel_upgrade, null)
  azure_policy_enabled                = try(each.value.azure_policy_enabled, false)
  disk_encryption_set_id              = try(each.value.disk_encryption_set_id, null)
  edge_zone                           = try(each.value.edge_zone, null)
  http_application_routing_enabled    = try(each.value.http_application_routing_enabled, false)
  image_cleaner_enabled               = try(each.value.image_cleaner_enabled, false)
  image_cleaner_interval_hours        = try(each.value.image_cleaner_enabled, false) ? try(each.value.image_cleaner_interval_hours, 48) : null
  local_account_disabled              = try(each.value.local_account_disabled, false)
  oidc_issuer_enabled                 = try(each.value.oidc_issuer_enabled, false)
  open_service_mesh_enabled           = try(each.value.open_service_mesh_enabled, false)
  private_cluster_enabled             = try(each.value.private_cluster_enabled, false)
  private_dns_zone_id                 = try(each.value.private_dns_zone_id, null)
  private_cluster_public_fqdn_enabled = try(each.value.private_cluster_public_fqdn_enabled, false)
  run_command_enabled                 = try(each.value.run_command_enabled, true)
  workload_identity_enabled           = try(each.value.workload_identity_enabled, false)
  support_plan                        = try(each.value.support_plan, "KubernetesOfficial")
  cost_analysis_enabled               = try(each.value.cost_analysis_enabled, false)
  tags                                = try(each.value.tags, {})

  # ============================================================================
  # DEFAULT NODE POOL
  # ============================================================================
  default_node_pool {
    name                         = try(each.value.default_node_pool_name, "default")
    vm_size                      = try(each.value.default_node_pool_vm_size, "Standard_D2_v2")
    auto_scaling_enabled         = try(each.value.enable_auto_scaling, true)
    node_count                   = try(each.value.enable_auto_scaling, true) ? null : try(each.value.default_node_pool_count, 3)
    min_count                    = try(each.value.enable_auto_scaling, true) ? try(each.value.min_node_count, 1) : null
    max_count                    = try(each.value.enable_auto_scaling, true) ? try(each.value.max_node_count, 5) : null
    zones                        = try(each.value.default_node_pool_zones, null)
    host_encryption_enabled      = try(each.value.default_node_pool_enable_host_encryption, false)
    node_public_ip_enabled       = try(each.value.default_node_pool_enable_node_public_ip, false)
    max_pods                     = try(each.value.default_node_pool_max_pods, 30)
    node_labels                  = try(each.value.default_node_pool_node_labels, {})
    only_critical_addons_enabled = try(each.value.default_node_pool_node_taints, null) != null && length(try(each.value.default_node_pool_node_taints, [])) > 0 ? contains(each.value.default_node_pool_node_taints, "CriticalAddonsOnly=true:NoSchedule") : null
    os_disk_size_gb              = try(each.value.default_node_pool_os_disk_size_gb, 128)
    os_disk_type                 = try(each.value.default_node_pool_os_disk_type, "Managed")
    os_sku                       = try(each.value.default_node_pool_os_sku, "Ubuntu")
    vnet_subnet_id               = try(each.value.default_node_pool_vnet_subnet_id, null)
    pod_subnet_id                = try(each.value.default_node_pool_pod_subnet_id, null)
    ultra_ssd_enabled            = try(each.value.default_node_pool_ultra_ssd_enabled, false)

    dynamic "upgrade_settings" {
      for_each = try(each.value.default_node_pool_upgrade_settings, null) != null ? [each.value.default_node_pool_upgrade_settings] : []
      content {
        max_surge = upgrade_settings.value.max_surge
      }
    }
  }

  # ============================================================================
  # IDENTITY
  # ============================================================================
  identity {
    type         = try(each.value.identity_type, "SystemAssigned")
    identity_ids = try(each.value.identity_type, "SystemAssigned") == "UserAssigned" ? each.value.identity_ids : null
  }

  # ============================================================================
  # NETWORK PROFILE
  # ============================================================================
  network_profile {
    network_plugin      = try(each.value.network_plugin, "azure")
    network_mode        = try(each.value.network_mode, null)
    network_policy      = try(each.value.network_policy, null)
    network_plugin_mode = try(each.value.network_plugin_mode, null)
    dns_service_ip      = try(each.value.dns_service_ip, null)
    service_cidr        = try(each.value.service_cidr, null)
    service_cidrs       = try(each.value.service_cidrs, null)
    pod_cidr            = try(each.value.pod_cidr, null)
    pod_cidrs           = try(each.value.pod_cidrs, null)
    ip_versions         = try(each.value.ip_versions, ["IPv4"])
    outbound_type       = try(each.value.outbound_type, "loadBalancer")
    load_balancer_sku   = try(each.value.load_balancer_sku, "standard")
    network_data_plane  = try(each.value.network_data_plane, null)

    dynamic "load_balancer_profile" {
      for_each = try(each.value.load_balancer_profile, null) != null ? [each.value.load_balancer_profile] : []
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
      for_each = try(each.value.nat_gateway_profile, null) != null ? [each.value.nat_gateway_profile] : []
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
    for_each = try(each.value.api_server_access_profile, null) != null ? [each.value.api_server_access_profile] : []
    content {
      authorized_ip_ranges = api_server_access_profile.value.authorized_ip_ranges
      subnet_id            = api_server_access_profile.value.subnet_id
    }
  }

  # ============================================================================
  # AUTO SCALER PROFILE
  # ============================================================================
  dynamic "auto_scaler_profile" {
    for_each = try(each.value.auto_scaler_profile, null) != null ? [each.value.auto_scaler_profile] : []
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
    for_each = try(each.value.azure_active_directory_role_based_access_control, null) != null ? [each.value.azure_active_directory_role_based_access_control] : []
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
    for_each = try(each.value.http_proxy_config, null) != null ? [each.value.http_proxy_config] : []
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
    for_each = try(each.value.key_management_service, null) != null ? [each.value.key_management_service] : []
    content {
      key_vault_key_id         = key_management_service.value.key_vault_key_id
      key_vault_network_access = key_management_service.value.key_vault_network_access
    }
  }

  # ============================================================================
  # KEY VAULT SECRETS PROVIDER
  # ============================================================================
  dynamic "key_vault_secrets_provider" {
    for_each = try(each.value.key_vault_secrets_provider, null) != null ? [each.value.key_vault_secrets_provider] : []
    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  # ============================================================================
  # KUBELET IDENTITY
  # ============================================================================
  dynamic "kubelet_identity" {
    for_each = try(each.value.kubelet_identity, null) != null ? [each.value.kubelet_identity] : []
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
    for_each = try(each.value.linux_profile, null) != null ? [each.value.linux_profile] : []
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
    for_each = try(each.value.maintenance_window, null) != null ? [each.value.maintenance_window] : []
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
    for_each = try(each.value.maintenance_window_auto_upgrade, null) != null ? [each.value.maintenance_window_auto_upgrade] : []
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
    for_each = try(each.value.maintenance_window_node_os, null) != null ? [each.value.maintenance_window_node_os] : []
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
    for_each = try(each.value.microsoft_defender, null) != null ? [each.value.microsoft_defender] : []
    content {
      log_analytics_workspace_id = microsoft_defender.value.log_analytics_workspace_id
    }
  }

  # ============================================================================
  # MONITOR METRICS
  # ============================================================================
  dynamic "monitor_metrics" {
    for_each = try(each.value.monitor_metrics, null) != null ? [each.value.monitor_metrics] : []
    content {
      annotations_allowed = monitor_metrics.value.annotations_allowed
      labels_allowed      = monitor_metrics.value.labels_allowed
    }
  }

  # ============================================================================
  # OMS AGENT
  # ============================================================================
  dynamic "oms_agent" {
    for_each = try(each.value.oms_agent, null) != null ? [each.value.oms_agent] : []
    content {
      log_analytics_workspace_id      = oms_agent.value.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = oms_agent.value.msi_auth_for_monitoring_enabled
    }
  }

  # ============================================================================
  # SERVICE MESH PROFILE
  # ============================================================================
  dynamic "service_mesh_profile" {
    for_each = try(each.value.service_mesh_profile, null) != null ? [each.value.service_mesh_profile] : []
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
    for_each = try(each.value.storage_profile, null) != null ? [each.value.storage_profile] : []
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
    for_each = try(each.value.web_app_routing, null) != null ? [each.value.web_app_routing] : []
    content {
      dns_zone_ids = web_app_routing.value.dns_zone_ids
    }
  }

  # ============================================================================
  # WINDOWS PROFILE
  # ============================================================================
  dynamic "windows_profile" {
    for_each = try(each.value.windows_profile, null) != null ? [each.value.windows_profile] : []
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
    for_each = try(each.value.workload_autoscaler_profile, null) != null ? [each.value.workload_autoscaler_profile] : []
    content {
      keda_enabled                    = workload_autoscaler_profile.value.keda_enabled
      vertical_pod_autoscaler_enabled = workload_autoscaler_profile.value.vertical_pod_autoscaler_enabled
    }
  }

  # ============================================================================
  # CONFIDENTIAL COMPUTING
  # ============================================================================
  dynamic "confidential_computing" {
    for_each = try(each.value.confidential_computing, null) != null ? [each.value.confidential_computing] : []
    content {
      sgx_quote_helper_enabled = confidential_computing.value.sgx_quote_helper_enabled
    }
  }
}
