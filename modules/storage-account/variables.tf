variable "storage_accounts" {
  description = "(Required) Map of storage accounts to create. Each key is a unique identifier and value contains the storage account configuration"
  type = map(object({
    name                              = string                        # (Required) Name of the storage account (3-24 chars, lowercase, numbers only)
    resource_group_name               = string                        # (Required) Name of the resource group
    location                          = string                        # (Required) Azure region for the storage account
    account_tier                      = optional(string, "Standard")  # (Optional) Standard or Premium
    account_replication_type          = optional(string, "LRS")       # (Optional) LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS
    account_kind                      = optional(string, "StorageV2") # (Optional) BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2
    access_tier                       = optional(string, "Hot")       # (Optional) Hot, Cool, Cold, Archive
    cross_tenant_replication_enabled  = optional(bool, false)
    edge_zone                         = optional(string)
    enable_https_traffic_only         = optional(bool, true)
    min_tls_version                   = optional(string, "TLS1_2") # (Optional) TLS1_0, TLS1_1, TLS1_2, TLS1_3
    allow_nested_items_to_be_public   = optional(bool, true)
    shared_access_key_enabled         = optional(bool, true)
    public_network_access_enabled     = optional(bool, true)
    default_to_oauth_authentication   = optional(bool, false)
    is_hns_enabled                    = optional(bool, false)
    nfsv3_enabled                     = optional(bool, false)
    large_file_share_enabled          = optional(bool, false)
    local_user_enabled                = optional(bool, false)
    queue_encryption_key_type         = optional(string, "Service")
    table_encryption_key_type         = optional(string, "Service")
    infrastructure_encryption_enabled = optional(bool, false)
    sftp_enabled                      = optional(bool, false)
    dns_endpoint_type                 = optional(string, "Standard") # (Optional) Standard or AzureDnsZone
    allowed_copy_scope                = optional(string)             # (Optional) AAD or PrivateLink
    https_traffic_only_enabled        = optional(bool)               # (Optional) Deprecated - use enable_https_traffic_only
    blob_properties = optional(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })))
      delete_retention_policy = optional(object({
        days                     = optional(number)
        permanent_delete_enabled = optional(bool)
      }))
      restore_policy = optional(object({
        days = number
      }))
      versioning_enabled            = optional(bool)
      change_feed_enabled           = optional(bool)
      change_feed_retention_in_days = optional(number)
      default_service_version       = optional(string)
      last_access_time_enabled      = optional(bool)
      container_delete_retention_policy = optional(object({
        days = optional(number)
      }))
    }))
    queue_properties = optional(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })))
      logging = optional(object({
        delete                = bool
        read                  = bool
        write                 = bool
        version               = string
        retention_policy_days = optional(number)
      }))
      minute_metrics = optional(object({
        enabled               = bool
        version               = string
        include_apis          = optional(bool)
        retention_policy_days = optional(number)
      }))
      hour_metrics = optional(object({
        enabled               = bool
        version               = string
        include_apis          = optional(bool)
        retention_policy_days = optional(number)
      }))
    }))
    static_website = optional(object({
      index_document     = optional(string)
      error_404_document = optional(string)
    }))
    share_properties = optional(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })))
      retention_policy = optional(object({
        days = optional(number)
      }))
      smb = optional(object({
        versions                        = optional(list(string))
        authentication_types            = optional(list(string))
        kerberos_ticket_encryption_type = optional(list(string))
        channel_encryption_type         = optional(list(string))
        multichannel_enabled            = optional(bool)
      }))
    }))
    network_rules = optional(object({
      default_action             = string
      bypass                     = optional(list(string))
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
      private_link_access = optional(list(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = optional(string)
      })))
    }))
    azure_files_authentication = optional(object({
      directory_type = string
      active_directory = optional(object({
        domain_name         = string
        netbios_domain_name = string
        forest_name         = string
        domain_guid         = string
        domain_sid          = string
        storage_sid         = string
      }))
      default_share_level_permission = optional(string)
    }))
    routing = optional(object({
      publish_internet_endpoints  = optional(bool)
      publish_microsoft_endpoints = optional(bool)
      choice                      = optional(string)
    }))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    customer_managed_key = optional(object({
      key_vault_key_id          = string
      user_assigned_identity_id = optional(string)
      managed_hsm_key_id        = optional(string)
    }))
    sas_policy = optional(object({
      expiration_period = string
      expiration_action = optional(string)
    }))
    immutability_policy = optional(object({
      allow_protected_append_writes = bool
      state                         = string
      period_since_creation_in_days = number
    }))
    tags = optional(map(string), {})
  }))

  validation {
    condition     = alltrue([for sa in var.storage_accounts : can(regex("^[a-z0-9]{3,24}$", sa.name))])
    error_message = "All storage account names must be 3-24 characters, lowercase letters and numbers only."
  }

  validation {
    condition     = alltrue([for sa in var.storage_accounts : length(sa.resource_group_name) > 0])
    error_message = "All storage accounts must have a resource group name specified."
  }

  validation {
    condition     = alltrue([for sa in var.storage_accounts : length(sa.location) > 0])
    error_message = "All storage accounts must have a location specified."
  }

  validation {
    condition     = alltrue([for sa in var.storage_accounts : contains(["Standard", "Premium"], sa.account_tier)])
    error_message = "All storage account tiers must be either Standard or Premium."
  }

  validation {
    condition     = alltrue([for sa in var.storage_accounts : contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], sa.account_replication_type)])
    error_message = "All storage account replication types must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }

  validation {
    condition     = alltrue([for sa in var.storage_accounts : contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], sa.account_kind)])
    error_message = "All storage account kinds must be one of: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2."
  }

  validation {
    condition     = alltrue([for sa in var.storage_accounts : contains(["Hot", "Cool", "Cold", "Archive"], sa.access_tier)])
    error_message = "All storage account access tiers must be one of: Hot, Cool, Cold, Archive."
  }

  validation {
    condition     = alltrue([for sa in var.storage_accounts : contains(["TLS1_0", "TLS1_1", "TLS1_2", "TLS1_3"], sa.min_tls_version)])
    error_message = "All storage account minimum TLS versions must be one of: TLS1_0, TLS1_1, TLS1_2, TLS1_3."
  }

  validation {
    condition     = alltrue([for sa in var.storage_accounts : contains(["Standard", "AzureDnsZone"], sa.dns_endpoint_type)])
    error_message = "All storage account DNS endpoint types must be either Standard or AzureDnsZone."
  }

  validation {
    condition     = alltrue([for sa in var.storage_accounts : sa.allowed_copy_scope == null || contains(["AAD", "PrivateLink"], sa.allowed_copy_scope)])
    error_message = "All storage account allowed copy scopes must be either AAD or PrivateLink."
  }

  validation {
    condition     = alltrue([for sa in var.storage_accounts : sa.identity == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], sa.identity.type)])
    error_message = "All storage account identity types must be one of: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
  }
}
