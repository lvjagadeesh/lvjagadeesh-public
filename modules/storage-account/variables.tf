variable "storage_account_name" {
  description = "(Required) Name of the storage account. Must be globally unique, 3-24 characters, lowercase letters and numbers only"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage account name must be 3-24 characters, lowercase letters and numbers only."
  }
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where the storage account will be created"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "location" {
  description = "(Required) Azure region where the storage account will be created"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must be specified."
  }
}

variable "account_tier" {
  description = "(Optional) Storage account tier. Valid values: Standard, Premium. Default: Standard"
  type        = string
  default     = "Standard"
  nullable    = false

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Account tier must be either Standard or Premium."
  }
}

variable "account_replication_type" {
  description = "(Optional) Storage account replication type. Valid values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS. Default: LRS"
  type        = string
  default     = "LRS"
  nullable    = false

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Account replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "account_kind" {
  description = "(Optional) Storage account kind. Valid values: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2. Default: StorageV2"
  type        = string
  default     = "StorageV2"
  nullable    = false

  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "Account kind must be one of: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2."
  }
}

variable "access_tier" {
  description = "(Optional) Access tier for BlobStorage and StorageV2. Valid values: Hot, Cool, Cold, Archive. Default: Hot"
  type        = string
  default     = "Hot"
  nullable    = false

  validation {
    condition     = contains(["Hot", "Cool", "Cold", "Archive"], var.access_tier)
    error_message = "Access tier must be one of: Hot, Cool, Cold, Archive."
  }
}

variable "cross_tenant_replication_enabled" {
  description = "(Optional) Should cross Tenant replication be enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "edge_zone" {
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Storage Account should exist"
  type        = string
  default     = null
}

variable "enable_https_traffic_only" {
  description = "(Optional) Boolean flag which forces HTTPS if enabled. Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "min_tls_version" {
  description = "(Optional) Minimum TLS version. Valid values: TLS1_0, TLS1_1, TLS1_2, TLS1_3. Default: TLS1_2"
  type        = string
  default     = "TLS1_2"
  nullable    = false

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2", "TLS1_3"], var.min_tls_version)
    error_message = "Minimum TLS version must be one of: TLS1_0, TLS1_1, TLS1_2, TLS1_3."
  }
}

variable "allow_nested_items_to_be_public" {
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public. Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "shared_access_key_enabled" {
  description = "(Optional) Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether the public network access is enabled. Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "default_to_oauth_authentication" {
  description = "(Optional) Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "is_hns_enabled" {
  description = "(Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "nfsv3_enabled" {
  description = "(Optional) Is NFSv3 protocol enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "large_file_share_enabled" {
  description = "(Optional) Is Large File Share Enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "local_user_enabled" {
  description = "(Optional) Is Local User Enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "queue_encryption_key_type" {
  description = "(Optional) The encryption type of the queue service. Valid values: Service, Account. Default: Service"
  type        = string
  default     = "Service"
  nullable    = false
}

variable "table_encryption_key_type" {
  description = "(Optional) The encryption type of the table service. Valid values: Service, Account. Default: Service"
  type        = string
  default     = "Service"
  nullable    = false
}

variable "infrastructure_encryption_enabled" {
  description = "(Optional) Is infrastructure encryption enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "sftp_enabled" {
  description = "(Optional) Boolean, enable SFTP for the storage account? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "dns_endpoint_type" {
  description = "(Optional) Specifies which DNS endpoint type to use. Valid values: Standard, AzureDnsZone. Default: Standard"
  type        = string
  default     = "Standard"
  nullable    = false

  validation {
    condition     = contains(["Standard", "AzureDnsZone"], var.dns_endpoint_type)
    error_message = "DNS endpoint type must be either Standard or AzureDnsZone."
  }
}

variable "allowed_copy_scope" {
  description = "(Optional) Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. Valid values: AAD, PrivateLink"
  type        = string
  default     = null

  validation {
    condition     = var.allowed_copy_scope == null || contains(["AAD", "PrivateLink"], var.allowed_copy_scope)
    error_message = "Allowed copy scope must be either AAD or PrivateLink."
  }
}

variable "https_traffic_only_enabled" {
  description = "(Optional) Deprecated - use enable_https_traffic_only"
  type        = bool
  default     = null
}

variable "blob_properties" {
  description = "(Optional) Blob properties configuration"
  type = object({
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
    versioning_enabled       = optional(bool)
    change_feed_enabled      = optional(bool)
    change_feed_retention_in_days = optional(number)
    default_service_version  = optional(string)
    last_access_time_enabled = optional(bool)
    container_delete_retention_policy = optional(object({
      days = optional(number)
    }))
  })
  default = null
}

variable "queue_properties" {
  description = "(Optional) Queue properties configuration"
  type = object({
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
  })
  default = null
}

variable "static_website" {
  description = "(Optional) Static website configuration"
  type = object({
    index_document     = optional(string)
    error_404_document = optional(string)
  })
  default = null
}

variable "share_properties" {
  description = "(Optional) Share properties configuration"
  type = object({
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
  })
  default = null
}

variable "network_rules" {
  description = "(Optional) Network rules configuration"
  type = object({
    default_action             = string                # (Required) Allow or Deny
    bypass                     = optional(list(string)) # (Optional) AzureServices, Logging, Metrics, None
    ip_rules                   = optional(list(string)) # (Optional) List of public IP or IP ranges in CIDR format
    virtual_network_subnet_ids = optional(list(string)) # (Optional) List of subnet IDs
    private_link_access = optional(list(object({       # (Optional) Private link access configuration
      endpoint_resource_id = string
      endpoint_tenant_id   = optional(string)
    })))
  })
  default = null
}

variable "azure_files_authentication" {
  description = "(Optional) Azure Files authentication configuration"
  type = object({
    directory_type = string # (Required) AADDS, AD, AADKERB
    active_directory = optional(object({
      domain_name         = string
      netbios_domain_name = string
      forest_name         = string
      domain_guid         = string
      domain_sid          = string
      storage_sid         = string
    }))
    default_share_level_permission = optional(string) # StorageFileDataSmbShareContributor, etc.
  })
  default = null
}

variable "routing" {
  description = "(Optional) Routing configuration"
  type = object({
    publish_internet_endpoints  = optional(bool)
    publish_microsoft_endpoints = optional(bool)
    choice                       = optional(string) # MicrosoftRouting, InternetRouting
  })
  default = null
}

variable "identity" {
  description = "(Optional) Managed Identity configuration"
  type = object({
    type         = string                # (Required) SystemAssigned, UserAssigned, SystemAssigned,UserAssigned
    identity_ids = optional(list(string)) # (Optional) List of User Assigned Identity IDs
  })
  default = null

  validation {
    condition     = var.identity == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity.type)
    error_message = "Identity type must be one of: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
  }
}

variable "customer_managed_key" {
  description = "(Optional) Customer managed key configuration for encryption"
  type = object({
    key_vault_key_id          = string           # (Required) The ID of the Key Vault Key
    user_assigned_identity_id = optional(string) # (Optional) User Assigned Identity ID
    managed_hsm_key_id        = optional(string) # (Optional) Managed HSM Key ID
  })
  default = null
}

variable "sas_policy" {
  description = "(Optional) SAS policy configuration"
  type = object({
    expiration_period = string           # (Required) The SAS expiration period in format of DD.HH:MM:SS
    expiration_action = optional(string) # (Optional) The SAS expiration action. Default: Log
  })
  default = null
}

variable "immutability_policy" {
  description = "(Optional) Immutability policy configuration"
  type = object({
    allow_protected_append_writes = bool
    state                         = string # (Required) Locked, Unlocked, Disabled
    period_since_creation_in_days = number
  })
  default = null
}

variable "tags" {
  description = "(Optional) Tags to apply to the storage account"
  type        = map(string)
  default     = {}
  nullable    = false
}
