resource "azurerm_storage_account" "this" {
  for_each = var.storage_accounts

  name                              = each.value.name
  resource_group_name               = each.value.resource_group_name
  location                          = each.value.location
  account_tier                      = each.value.account_tier
  account_replication_type          = each.value.account_replication_type
  account_kind                      = each.value.account_kind
  access_tier                       = each.value.access_tier
  cross_tenant_replication_enabled  = each.value.cross_tenant_replication_enabled
  edge_zone                         = each.value.edge_zone
  https_traffic_only_enabled        = each.value.enable_https_traffic_only
  min_tls_version                   = each.value.min_tls_version
  allow_nested_items_to_be_public   = each.value.allow_nested_items_to_be_public
  shared_access_key_enabled         = each.value.shared_access_key_enabled
  public_network_access_enabled     = each.value.public_network_access_enabled
  default_to_oauth_authentication   = each.value.default_to_oauth_authentication
  is_hns_enabled                    = each.value.is_hns_enabled
  nfsv3_enabled                     = each.value.nfsv3_enabled
  large_file_share_enabled          = each.value.large_file_share_enabled
  local_user_enabled                = each.value.local_user_enabled
  queue_encryption_key_type         = each.value.queue_encryption_key_type
  table_encryption_key_type         = each.value.table_encryption_key_type
  infrastructure_encryption_enabled = each.value.infrastructure_encryption_enabled
  sftp_enabled                      = each.value.sftp_enabled
  dns_endpoint_type                 = each.value.dns_endpoint_type
  allowed_copy_scope                = each.value.allowed_copy_scope
  tags                              = each.value.tags

  dynamic "blob_properties" {
    for_each = each.value.blob_properties != null ? [each.value.blob_properties] : []
    content {
      versioning_enabled            = try(blob_properties.value.versioning_enabled, null)
      change_feed_enabled           = try(blob_properties.value.change_feed_enabled, null)
      change_feed_retention_in_days = try(blob_properties.value.change_feed_retention_in_days, null)
      default_service_version       = try(blob_properties.value.default_service_version, null)
      last_access_time_enabled      = try(blob_properties.value.last_access_time_enabled, null)

      dynamic "cors_rule" {
        for_each = try(blob_properties.value.cors_rule, [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = try(blob_properties.value.delete_retention_policy, null) != null ? [blob_properties.value.delete_retention_policy] : []
        content {
          days                     = try(delete_retention_policy.value.days, null)
          permanent_delete_enabled = try(delete_retention_policy.value.permanent_delete_enabled, null)
        }
      }

      dynamic "restore_policy" {
        for_each = try(blob_properties.value.restore_policy, null) != null ? [blob_properties.value.restore_policy] : []
        content {
          days = restore_policy.value.days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = try(blob_properties.value.container_delete_retention_policy, null) != null ? [blob_properties.value.container_delete_retention_policy] : []
        content {
          days = try(container_delete_retention_policy.value.days, null)
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = each.value.queue_properties != null ? [each.value.queue_properties] : []
    content {
      dynamic "cors_rule" {
        for_each = try(queue_properties.value.cors_rule, [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = try(queue_properties.value.logging, null) != null ? [queue_properties.value.logging] : []
        content {
          delete                = logging.value.delete
          read                  = logging.value.read
          write                 = logging.value.write
          version               = logging.value.version
          retention_policy_days = try(logging.value.retention_policy_days, null)
        }
      }

      dynamic "minute_metrics" {
        for_each = try(queue_properties.value.minute_metrics, null) != null ? [queue_properties.value.minute_metrics] : []
        content {
          enabled               = minute_metrics.value.enabled
          version               = minute_metrics.value.version
          include_apis          = try(minute_metrics.value.include_apis, null)
          retention_policy_days = try(minute_metrics.value.retention_policy_days, null)
        }
      }

      dynamic "hour_metrics" {
        for_each = try(queue_properties.value.hour_metrics, null) != null ? [queue_properties.value.hour_metrics] : []
        content {
          enabled               = hour_metrics.value.enabled
          version               = hour_metrics.value.version
          include_apis          = try(hour_metrics.value.include_apis, null)
          retention_policy_days = try(hour_metrics.value.retention_policy_days, null)
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = each.value.static_website != null ? [each.value.static_website] : []
    content {
      index_document     = try(static_website.value.index_document, null)
      error_404_document = try(static_website.value.error_404_document, null)
    }
  }

  dynamic "share_properties" {
    for_each = each.value.share_properties != null ? [each.value.share_properties] : []
    content {
      dynamic "cors_rule" {
        for_each = try(share_properties.value.cors_rule, [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = try(share_properties.value.retention_policy, null) != null ? [share_properties.value.retention_policy] : []
        content {
          days = try(retention_policy.value.days, null)
        }
      }

      dynamic "smb" {
        for_each = try(share_properties.value.smb, null) != null ? [share_properties.value.smb] : []
        content {
          versions                        = try(smb.value.versions, null)
          authentication_types            = try(smb.value.authentication_types, null)
          kerberos_ticket_encryption_type = try(smb.value.kerberos_ticket_encryption_type, null)
          channel_encryption_type         = try(smb.value.channel_encryption_type, null)
          multichannel_enabled            = try(smb.value.multichannel_enabled, null)
        }
      }
    }
  }

  dynamic "network_rules" {
    for_each = each.value.network_rules != null ? [each.value.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = try(network_rules.value.bypass, ["AzureServices"])
      ip_rules                   = try(network_rules.value.ip_rules, [])
      virtual_network_subnet_ids = try(network_rules.value.virtual_network_subnet_ids, [])

      dynamic "private_link_access" {
        for_each = try(network_rules.value.private_link_access, [])
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = try(private_link_access.value.endpoint_tenant_id, null)
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = each.value.azure_files_authentication != null ? [each.value.azure_files_authentication] : []
    content {
      directory_type = azure_files_authentication.value.directory_type

      dynamic "active_directory" {
        for_each = try(azure_files_authentication.value.active_directory, null) != null ? [azure_files_authentication.value.active_directory] : []
        content {
          domain_name         = active_directory.value.domain_name
          netbios_domain_name = active_directory.value.netbios_domain_name
          forest_name         = active_directory.value.forest_name
          domain_guid         = active_directory.value.domain_guid
          domain_sid          = active_directory.value.domain_sid
          storage_sid         = active_directory.value.storage_sid
        }
      }

      default_share_level_permission = try(azure_files_authentication.value.default_share_level_permission, null)
    }
  }

  dynamic "routing" {
    for_each = each.value.routing != null ? [each.value.routing] : []
    content {
      publish_internet_endpoints  = try(routing.value.publish_internet_endpoints, null)
      publish_microsoft_endpoints = try(routing.value.publish_microsoft_endpoints, null)
      choice                      = try(routing.value.choice, null)
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }

  dynamic "customer_managed_key" {
    for_each = each.value.customer_managed_key != null ? [each.value.customer_managed_key] : []
    content {
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      user_assigned_identity_id = try(customer_managed_key.value.user_assigned_identity_id, null)
      managed_hsm_key_id        = try(customer_managed_key.value.managed_hsm_key_id, null)
    }
  }

  dynamic "sas_policy" {
    for_each = each.value.sas_policy != null ? [each.value.sas_policy] : []
    content {
      expiration_period = sas_policy.value.expiration_period
      expiration_action = try(sas_policy.value.expiration_action, "Log")
    }
  }

  dynamic "immutability_policy" {
    for_each = each.value.immutability_policy != null ? [each.value.immutability_policy] : []
    content {
      allow_protected_append_writes = immutability_policy.value.allow_protected_append_writes
      state                         = immutability_policy.value.state
      period_since_creation_in_days = immutability_policy.value.period_since_creation_in_days
    }
  }
}
