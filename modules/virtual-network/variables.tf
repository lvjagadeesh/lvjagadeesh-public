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

variable "bgp_community" {
  description = "(Optional) The BGP community attribute in format <as-number>:<community-value>"
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "(Optional) List of IP addresses of DNS servers"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "edge_zone" {
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist"
  type        = string
  default     = null
}

variable "flow_timeout_in_minutes" {
  description = "(Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes"
  type        = number
  default     = null

  validation {
    condition     = var.flow_timeout_in_minutes == null || (var.flow_timeout_in_minutes >= 4 && var.flow_timeout_in_minutes <= 30)
    error_message = "Flow timeout must be between 4 and 30 minutes."
  }
}

variable "ddos_protection_plan" {
  description = "(Optional) DDoS protection plan configuration"
  type = object({
    id     = string # (Required) The ID of DDoS Protection Plan
    enable = bool   # (Required) Enable/disable DDoS Protection Plan on Virtual Network
  })
  default = null
}

variable "encryption" {
  description = "(Optional) Encryption configuration for the virtual network"
  type = object({
    enforcement = string # (Required) Specifies if the encrypted Virtual Network allows VM that does not support encryption. Possible values: AllowUnencrypted, DropUnencrypted
  })
  default = null

  validation {
    condition     = var.encryption == null || contains(["AllowUnencrypted", "DropUnencrypted"], var.encryption.enforcement)
    error_message = "Encryption enforcement must be either AllowUnencrypted or DropUnencrypted."
  }
}

variable "subnets" {
  description = "(Optional) List of subnets to create within the virtual network"
  type = list(object({
    name                                          = string                # (Required) Name of the subnet
    address_prefixes                              = list(string)          # (Required) Address prefixes in CIDR notation
    private_endpoint_network_policies             = optional(string)      # (Optional) Enable or Disable network policies: Disabled, Enabled, NetworkSecurityGroupEnabled, RouteTableEnabled
    private_link_service_network_policies_enabled = optional(bool)        # (Optional) Enable or Disable network policies for the private link service
    service_endpoints                             = optional(list(string)) # (Optional) List of Service endpoints to associate
    service_endpoint_policy_ids                   = optional(list(string)) # (Optional) List of Service Endpoint Policy IDs
    delegations = optional(list(object({                                  # (Optional) Subnet delegations
      name = string                                                       # (Required) Name of the delegation
      service_delegation = object({                                       # (Required) Service delegation configuration
        name    = string               # (Required) Service name
        actions = optional(list(string)) # (Optional) List of actions
      })
    })))
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
