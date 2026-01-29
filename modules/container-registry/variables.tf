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

variable "georeplications" {
  description = "(Optional) Geo-replications for the registry. Requires Premium SKU. Default: []"
  type = list(object({
    location                = string      # (Required) Azure region for replication
    zone_redundancy_enabled = bool        # (Required) Enable zone redundancy
    tags                    = map(string) # (Optional) Tags for this replication
  }))
  default  = []
  nullable = false
  # Note: Geo-replication requires Premium SKU
}

variable "network_rule_default_action" {
  description = "(Optional) Default action for network rules. Valid values: Allow, Deny. Default: Deny"
  type        = string
  default     = "Deny"
  nullable    = false

  validation {
    condition     = contains(["Allow", "Deny"], var.network_rule_default_action)
    error_message = "Network rule default action must be either Allow or Deny."
  }
}

variable "tags" {
  description = "(Optional) Tags to apply to the Container Registry"
  type        = map(string)
  default     = {}
  nullable    = false
}
