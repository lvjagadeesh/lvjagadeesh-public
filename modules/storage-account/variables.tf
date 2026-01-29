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
  description = "(Optional) Access tier for BlobStorage and StorageV2. Valid values: Hot, Cool. Default: Hot"
  type        = string
  default     = "Hot"
  nullable    = false

  validation {
    condition     = contains(["Hot", "Cool"], var.access_tier)
    error_message = "Access tier must be either Hot or Cool."
  }
}

variable "min_tls_version" {
  description = "(Optional) Minimum TLS version. Valid values: TLS1_0, TLS1_1, TLS1_2. Default: TLS1_2"
  type        = string
  default     = "TLS1_2"
  nullable    = false

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "Minimum TLS version must be one of: TLS1_0, TLS1_1, TLS1_2."
  }
}

variable "blob_retention_days" {
  description = "(Optional) Number of days to retain deleted blobs. Default: 7"
  type        = number
  default     = 7
  nullable    = false

  validation {
    condition     = var.blob_retention_days >= 1 && var.blob_retention_days <= 365
    error_message = "Blob retention days must be between 1 and 365."
  }
}

variable "network_rules_default_action" {
  description = "(Optional) Default action for network rules. Valid values: Allow, Deny. Default: Deny"
  type        = string
  default     = "Deny"
  nullable    = false

  validation {
    condition     = contains(["Allow", "Deny"], var.network_rules_default_action)
    error_message = "Network rules default action must be either Allow or Deny."
  }
}

variable "network_rules_bypass" {
  description = "(Optional) Bypass network rules for services. Valid values: AzureServices, Logging, Metrics, None. Default: [AzureServices]"
  type        = list(string)
  default     = ["AzureServices"]
  nullable    = false

  validation {
    condition     = alltrue([for v in var.network_rules_bypass : contains(["AzureServices", "Logging", "Metrics", "None"], v)])
    error_message = "Network rules bypass must contain valid values: AzureServices, Logging, Metrics, None."
  }
}

variable "tags" {
  description = "(Optional) Tags to apply to the storage account"
  type        = map(string)
  default     = {}
  nullable    = false
}
