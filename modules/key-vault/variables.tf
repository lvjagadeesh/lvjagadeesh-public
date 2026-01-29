variable "key_vaults" {
  description = "(Required) Map of key vaults to create. Each key is a unique identifier and value contains the key vault configuration"
  type = map(object({
    name                                    = string                                                                # (Required) Name of the Key Vault. Must be globally unique, 3-24 characters
    location                                = string                                                                # (Required) Azure region where the Key Vault will be created
    resource_group_name                     = string                                                                # (Required) Name of the resource group where the Key Vault will be created
    sku_name                                = optional(string, "standard")                                          # (Optional) SKU name for Key Vault. Valid values: standard, premium
    soft_delete_retention_days              = optional(number, 90)                                                  # (Optional) Number of days to retain deleted key vaults. Must be between 7 and 90
    purge_protection_enabled                = optional(bool, true)                                                  # (Optional) Enable purge protection
    network_acls_bypass                     = optional(string, "AzureServices")                                     # (Optional) Bypass network ACLs for services. Valid values: AzureServices, None
    network_acls_default_action             = optional(string, "Deny")                                              # (Optional) Default action for network ACLs. Valid values: Allow, Deny
    key_permissions                         = optional(list(string), ["Get", "List", "Create", "Delete", "Update"]) # (Optional) Key permissions for the access policy
    secret_permissions                      = optional(list(string), ["Get", "List", "Set", "Delete"])              # (Optional) Secret permissions for the access policy
    certificate_permissions                 = optional(list(string), ["Get", "List", "Create", "Delete"])           # (Optional) Certificate permissions for the access policy
    tags                                    = optional(map(string), {})                                             # (Optional) Tags to apply to the Key Vault
    tenant_id                               = optional(string)                                                      # (Optional) Azure Active Directory tenant ID for authenticating requests to the Key Vault
    enabled_for_deployment                  = optional(bool, false)                                                 # (Optional) If true, Azure Virtual Machines are permitted to retrieve certificates
    enabled_for_disk_encryption             = optional(bool, false)                                                 # (Optional) If true, Azure Disk Encryption is permitted to retrieve secrets
    enabled_for_template_deployment         = optional(bool, false)                                                 # (Optional) If true, Azure Resource Manager is permitted to retrieve secrets
    rbac_authorization_enabled              = optional(bool, false)                                                 # (Optional) If true, the Key Vault will use RBAC for authorization
    public_network_access_enabled           = optional(bool, true)                                                  # (Optional) If true, public network access is enabled
    network_acls_ip_rules                   = optional(list(string), [])                                            # (Optional) List of IP addresses or CIDR blocks
    network_acls_virtual_network_subnet_ids = optional(list(string), [])                                            # (Optional) List of subnet IDs
    create_default_access_policy            = optional(bool, true)                                                  # (Optional) If true, creates a default access policy for the current user/service principal
    storage_permissions                     = optional(list(string), [])                                            # (Optional) Storage permissions for the default access policy
    additional_access_policies = optional(list(object({
      tenant_id               = string
      object_id               = string
      application_id          = optional(string)
      key_permissions         = optional(list(string), [])
      secret_permissions      = optional(list(string), [])
      certificate_permissions = optional(list(string), [])
      storage_permissions     = optional(list(string), [])
    })), [])
    contacts = optional(list(object({
      email = string
      name  = optional(string)
      phone = optional(string)
    })), [])
  }))

  validation {
    condition     = alltrue([for kv in var.key_vaults : can(regex("^[a-zA-Z0-9-]{3,24}$", kv.name))])
    error_message = "All Key Vault names must be 3-24 characters, alphanumeric and hyphens only."
  }

  validation {
    condition     = alltrue([for kv in var.key_vaults : length(kv.location) > 0])
    error_message = "All Key Vaults must have a location specified."
  }

  validation {
    condition     = alltrue([for kv in var.key_vaults : length(kv.resource_group_name) > 0])
    error_message = "All Key Vaults must have a resource group name specified."
  }

  validation {
    condition     = alltrue([for kv in var.key_vaults : contains(["standard", "premium"], kv.sku_name)])
    error_message = "All Key Vault SKU names must be either standard or premium."
  }

  validation {
    condition     = alltrue([for kv in var.key_vaults : kv.soft_delete_retention_days >= 7 && kv.soft_delete_retention_days <= 90])
    error_message = "All Key Vault soft delete retention days must be between 7 and 90."
  }

  validation {
    condition     = alltrue([for kv in var.key_vaults : contains(["AzureServices", "None"], kv.network_acls_bypass)])
    error_message = "All Key Vault network ACLs bypass must be either AzureServices or None."
  }

  validation {
    condition     = alltrue([for kv in var.key_vaults : contains(["Allow", "Deny"], kv.network_acls_default_action)])
    error_message = "All Key Vault network ACLs default action must be either Allow or Deny."
  }

  validation {
    condition = alltrue([
      for kv in var.key_vaults :
      alltrue([
        for ip in kv.network_acls_ip_rules :
        can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/([0-9]|[1-2][0-9]|3[0-2]))?$", ip))
      ])
    ])
    error_message = "All IP rules must be valid IPv4 addresses (0-255 per octet) or CIDR blocks with prefix length 0-32."
  }

  validation {
    condition = alltrue([
      for kv in var.key_vaults :
      alltrue([
        for perm in kv.storage_permissions :
        contains([
          "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List",
          "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore",
          "Set", "SetSAS", "Update"
        ], perm)
      ])
    ])
    error_message = "All storage permissions must be valid values: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS, Update."
  }

  validation {
    condition = alltrue([
      for kv in var.key_vaults :
      alltrue([
        for contact in kv.contacts :
        can(regex("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", contact.email))
      ])
    ])
    error_message = "All contact emails must be valid email addresses in standard format (user@domain.com)."
  }
}
