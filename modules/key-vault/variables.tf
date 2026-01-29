variable "key_vault_name" {
  description = "(Required) Name of the Key Vault. Must be globally unique, 3-24 characters"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,24}$", var.key_vault_name))
    error_message = "Key Vault name must be 3-24 characters, alphanumeric and hyphens only."
  }
}

variable "location" {
  description = "(Required) Azure region where the Key Vault will be created"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must be specified."
  }
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where the Key Vault will be created"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "sku_name" {
  description = "(Optional) SKU name for Key Vault. Valid values: standard, premium. Default: standard"
  type        = string
  default     = "standard"
  nullable    = false

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "SKU name must be either standard or premium."
  }
}

variable "soft_delete_retention_days" {
  description = "(Optional) Number of days to retain deleted key vaults. Must be between 7 and 90. Default: 90"
  type        = number
  default     = 90
  nullable    = false

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention days must be between 7 and 90."
  }
}

variable "purge_protection_enabled" {
  description = "(Optional) Enable purge protection. Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "network_acls_bypass" {
  description = "(Optional) Bypass network ACLs for services. Valid values: AzureServices, None. Default: AzureServices"
  type        = string
  default     = "AzureServices"
  nullable    = false

  validation {
    condition     = contains(["AzureServices", "None"], var.network_acls_bypass)
    error_message = "Network ACLs bypass must be either AzureServices or None."
  }
}

variable "network_acls_default_action" {
  description = "(Optional) Default action for network ACLs. Valid values: Allow, Deny. Default: Deny"
  type        = string
  default     = "Deny"
  nullable    = false

  validation {
    condition     = contains(["Allow", "Deny"], var.network_acls_default_action)
    error_message = "Network ACLs default action must be either Allow or Deny."
  }
}

variable "key_permissions" {
  description = "(Optional) Key permissions for the access policy. Default: [Get, List, Create, Delete, Update]"
  type        = list(string)
  default     = ["Get", "List", "Create", "Delete", "Update"]
  nullable    = false
}

variable "secret_permissions" {
  description = "(Optional) Secret permissions for the access policy. Default: [Get, List, Set, Delete]"
  type        = list(string)
  default     = ["Get", "List", "Set", "Delete"]
  nullable    = false
}

variable "certificate_permissions" {
  description = "(Optional) Certificate permissions for the access policy. Default: [Get, List, Create, Delete]"
  type        = list(string)
  default     = ["Get", "List", "Create", "Delete"]
  nullable    = false
}

variable "tags" {
  description = "(Optional) Tags to apply to the Key Vault"
  type        = map(string)
  default     = {}
  nullable    = false
}
