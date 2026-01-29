variable "vnet_name" {
  description = "(Required) Name of the virtual network"
  type        = string

  validation {
    condition     = length(var.vnet_name) > 0 && length(var.vnet_name) <= 64
    error_message = "Virtual network name must be between 1 and 64 characters."
  }
}

variable "address_space" {
  description = "(Required) Address space for the virtual network in CIDR notation"
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "At least one address space must be specified."
  }
}

variable "location" {
  description = "(Required) Azure region where the virtual network will be created"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must be specified."
  }
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where the virtual network will be created"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "subnets" {
  description = "(Optional) List of subnets to create within the virtual network"
  type = list(object({
    name             = string       # (Required) Name of the subnet
    address_prefixes = list(string) # (Required) Address prefixes in CIDR notation
  }))
  default  = []
  nullable = false
}

variable "tags" {
  description = "(Optional) Tags to apply to the virtual network"
  type        = map(string)
  default     = {}
  nullable    = false
}
