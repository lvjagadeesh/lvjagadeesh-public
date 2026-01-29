variable "virtual_networks" {
  description = "(Required) Map of virtual networks to create"
  type = map(object({
    name                    = string                # (Required) Name of the virtual network
    address_space           = list(string)          # (Required) Address space for the virtual network in CIDR notation
    location                = string                # (Required) Azure region where the virtual network will be created
    resource_group_name     = string                # (Required) Name of the resource group where the virtual network will be created
    bgp_community           = optional(string)      # (Optional) The BGP community attribute in format <as-number>:<community-value>
    dns_servers             = optional(list(string)) # (Optional) List of IP addresses of DNS servers
    edge_zone               = optional(string)      # (Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist
    flow_timeout_in_minutes = optional(number)      # (Optional) The flow timeout in minutes for the Virtual Network (4-30 minutes)
    ddos_protection_plan = optional(object({        # (Optional) DDoS protection plan configuration
      id     = string                               # (Required) The ID of DDoS Protection Plan
      enable = bool                                 # (Required) Enable/disable DDoS Protection Plan on Virtual Network
    }))
    encryption = optional(object({                  # (Optional) Encryption configuration for the virtual network
      enforcement = string                          # (Required) Specifies if the encrypted Virtual Network allows VM that does not support encryption. Possible values: AllowUnencrypted, DropUnencrypted
    }))
    subnets = optional(list(object({                # (Optional) List of subnets to create within the virtual network
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
    })))
    tags = optional(map(string)) # (Optional) Tags to apply to the virtual network
  }))

  validation {
    condition     = alltrue([for k, v in var.virtual_networks : length(v.name) > 0 && length(v.name) <= 64])
    error_message = "Virtual network name must be between 1 and 64 characters."
  }

  validation {
    condition     = alltrue([for k, v in var.virtual_networks : length(v.address_space) > 0])
    error_message = "At least one address space must be specified for each virtual network."
  }

  validation {
    condition     = alltrue([for k, v in var.virtual_networks : length(v.location) > 0])
    error_message = "Location must be specified for each virtual network."
  }

  validation {
    condition     = alltrue([for k, v in var.virtual_networks : length(v.resource_group_name) > 0])
    error_message = "Resource group name must be specified for each virtual network."
  }

  validation {
    condition = alltrue([
      for k, v in var.virtual_networks :
      v.flow_timeout_in_minutes == null || (v.flow_timeout_in_minutes >= 4 && v.flow_timeout_in_minutes <= 30)
    ])
    error_message = "Flow timeout must be between 4 and 30 minutes."
  }

  validation {
    condition = alltrue([
      for k, v in var.virtual_networks :
      v.encryption == null || contains(["AllowUnencrypted", "DropUnencrypted"], v.encryption.enforcement)
    ])
    error_message = "Encryption enforcement must be either AllowUnencrypted or DropUnencrypted."
  }
}
