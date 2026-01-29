variable "container_registry_name" {
  description = "(Required) Name of the Container Registry. Must be globally unique, 5-50 characters, alphanumeric only"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{5,50}$", var.container_registry_name))
    error_message = "Container Registry name must be 5-50 characters, alphanumeric only."
  }
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where the Container Registry will be created"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "location" {
  description = "(Required) Azure region where the Container Registry will be created"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must be specified."
  }
}

variable "sku" {
  description = "(Optional) SKU for the Container Registry. Valid values: Basic, Standard, Premium. Default: Standard"
  type        = string
  default     = "Standard"
  nullable    = false

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be one of: Basic, Standard, Premium."
  }
}

variable "admin_enabled" {
  description = "(Optional) Enable admin user for the registry. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for the container registry. Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "quarantine_policy_enabled" {
  description = "(Optional) Boolean value that indicates whether quarantine policy is enabled. Requires Premium SKU. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "zone_redundancy_enabled" {
  description = "(Optional) Whether zone redundancy is enabled for this Container Registry. Requires Premium SKU and can only be set at creation. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "export_policy_enabled" {
  description = "(Optional) Boolean value that indicates whether export policy is enabled. Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "anonymous_pull_enabled" {
  description = "(Optional) Whether anonymous pull access is allowed. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "data_endpoint_enabled" {
  description = "(Optional) Whether to enable dedicated data endpoints for this Container Registry. Requires Premium SKU. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "network_rule_bypass_option" {
  description = "(Optional) Whether to allow trusted Azure services to access a network restricted Container Registry. Possible values: AzureServices, None. Default: AzureServices"
  type        = string
  default     = "AzureServices"
  nullable    = false

  validation {
    condition     = contains(["AzureServices", "None"], var.network_rule_bypass_option)
    error_message = "Network rule bypass option must be either AzureServices or None."
  }
}

variable "georeplications" {
  description = "(Optional) Geo-replications for the registry. Requires Premium SKU. Default: []"
  type = list(object({
    location                  = string                # (Required) Azure region for replication
    zone_redundancy_enabled   = optional(bool)        # (Optional) Enable zone redundancy
    regional_endpoint_enabled = optional(bool)        # (Optional) Enable regional endpoint
    tags                      = optional(map(string)) # (Optional) Tags for this replication
  }))
  default  = []
  nullable = false
  # Note: Geo-replication requires Premium SKU
}

variable "network_rule_set" {
  description = "(Optional) Network rule set configuration for the Container Registry"
  type = object({
    default_action = optional(string) # (Optional) Default action for network rules. Valid values: Allow, Deny
    ip_rule = optional(list(object({
      action   = string # (Required) Action for the IP rule. Must be Allow
      ip_range = string # (Required) IP address or CIDR range
    })))
  })
  default  = null
  nullable = true
}

variable "retention_policy_in_days" {
  description = "(Optional) Number of days to retain an untagged manifest after which it gets purged. Requires Premium SKU. Value between 0 and 365"
  type        = number
  default     = null
  nullable    = true

  validation {
    condition     = var.retention_policy_in_days == null || (var.retention_policy_in_days >= 0 && var.retention_policy_in_days <= 365)
    error_message = "Retention policy must be between 0 and 365 days."
  }
}

variable "trust_policy_enabled" {
  description = "(Optional) Boolean value that indicates whether the trust policy is enabled. Requires Premium SKU. Default: null"
  type        = bool
  default     = null
  nullable    = true
}

variable "identity" {
  description = "(Optional) Managed identity configuration for the Container Registry"
  type = object({
    type         = string                 # (Required) Type of identity. Possible values: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned
    identity_ids = optional(list(string)) # (Optional) List of User Assigned Identity IDs
  })
  default  = null
  nullable = true

  validation {
    condition = var.identity == null || contains(
      ["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"],
      var.identity.type
    )
    error_message = "Identity type must be one of: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
  }
}

variable "encryption" {
  description = "(Optional) Encryption configuration using customer-managed key. Requires Premium SKU"
  type = object({
    key_vault_key_id   = string # (Required) Key Vault Key ID for encryption
    identity_client_id = string # (Required) Client ID of the managed identity
  })
  default  = null
  nullable = true
}

variable "tags" {
  description = "(Optional) Tags to apply to the Container Registry"
  type        = map(string)
  default     = {}
  nullable    = false
}
