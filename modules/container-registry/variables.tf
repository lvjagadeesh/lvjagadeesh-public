variable "container_registries" {
  description = "(Required) Map of container registries to create. Each key is a unique identifier and value contains the container registry configuration"
  type = map(object({
    name                          = string                            # (Required) Name of the Container Registry. Must be globally unique, 5-50 characters, alphanumeric only
    resource_group_name           = string                            # (Required) Name of the resource group where the Container Registry will be created
    location                      = string                            # (Required) Azure region where the Container Registry will be created
    sku                           = optional(string, "Standard")      # (Optional) SKU for the Container Registry. Valid values: Basic, Standard, Premium
    admin_enabled                 = optional(bool, false)             # (Optional) Enable admin user for the registry
    public_network_access_enabled = optional(bool, true)              # (Optional) Whether public network access is allowed for the container registry
    quarantine_policy_enabled     = optional(bool, false)             # (Optional) Whether quarantine policy is enabled. Requires Premium SKU
    zone_redundancy_enabled       = optional(bool, false)             # (Optional) Whether zone redundancy is enabled. Requires Premium SKU and can only be set at creation
    export_policy_enabled         = optional(bool, true)              # (Optional) Whether export policy is enabled
    anonymous_pull_enabled        = optional(bool, false)             # (Optional) Whether anonymous pull access is allowed
    data_endpoint_enabled         = optional(bool, false)             # (Optional) Whether to enable dedicated data endpoints. Requires Premium SKU
    network_rule_bypass_option    = optional(string, "AzureServices") # (Optional) Whether to allow trusted Azure services to access a network restricted Container Registry. Possible values: AzureServices, None
    georeplications = optional(list(object({
      location                  = string                # (Required) Azure region for replication
      zone_redundancy_enabled   = optional(bool)        # (Optional) Enable zone redundancy
      regional_endpoint_enabled = optional(bool)        # (Optional) Enable regional endpoint
      tags                      = optional(map(string)) # (Optional) Tags for this replication
    })), [])
    network_rule_set = optional(object({
      default_action = optional(string) # (Optional) Default action for network rules. Valid values: Allow, Deny
      ip_rule = optional(list(object({
        action   = string # (Required) Action for the IP rule. Must be Allow
        ip_range = string # (Required) IP address or CIDR range
      })))
    }))
    retention_policy_in_days = optional(number) # (Optional) Number of days to retain an untagged manifest after which it gets purged. Requires Premium SKU. Value between 0 and 365
    trust_policy_enabled     = optional(bool)   # (Optional) Whether the trust policy is enabled. Requires Premium SKU
    identity = optional(object({
      type         = string                 # (Required) Type of identity. Possible values: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned
      identity_ids = optional(list(string)) # (Optional) List of User Assigned Identity IDs
    }))
    encryption = optional(object({
      key_vault_key_id   = string # (Required) Key Vault Key ID for encryption
      identity_client_id = string # (Required) Client ID of the managed identity
    }))
    tags = optional(map(string), {}) # (Optional) Tags to apply to the Container Registry
  }))

  validation {
    condition     = alltrue([for cr in var.container_registries : can(regex("^[a-zA-Z0-9]{5,50}$", cr.name))])
    error_message = "All Container Registry names must be 5-50 characters, alphanumeric only."
  }

  validation {
    condition     = alltrue([for cr in var.container_registries : length(cr.resource_group_name) > 0])
    error_message = "All container registries must have a resource group name specified."
  }

  validation {
    condition     = alltrue([for cr in var.container_registries : length(cr.location) > 0])
    error_message = "All container registries must have a location specified."
  }

  validation {
    condition     = alltrue([for cr in var.container_registries : contains(["Basic", "Standard", "Premium"], cr.sku)])
    error_message = "All container registry SKUs must be one of: Basic, Standard, Premium."
  }

  validation {
    condition     = alltrue([for cr in var.container_registries : contains(["AzureServices", "None"], cr.network_rule_bypass_option)])
    error_message = "All container registry network rule bypass options must be either AzureServices or None."
  }

  validation {
    condition     = alltrue([for cr in var.container_registries : cr.retention_policy_in_days == null || (cr.retention_policy_in_days >= 0 && cr.retention_policy_in_days <= 365)])
    error_message = "All container registry retention policies must be between 0 and 365 days."
  }

  validation {
    condition = alltrue([for cr in var.container_registries : cr.identity == null || contains(
      ["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"],
      cr.identity.type
    )])
    error_message = "All container registry identity types must be one of: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
  }
}
