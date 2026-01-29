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

# ========================================
# Core Feature Enablement Variables
# ========================================

variable "tenant_id" {
  description = "(Optional) Azure Active Directory tenant ID for authenticating requests to the Key Vault. If not specified, uses the current tenant ID"
  type        = string
  default     = null
}

variable "enabled_for_deployment" {
  description = "(Optional) If true, Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "enabled_for_disk_encryption" {
  description = "(Optional) If true, Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "enabled_for_template_deployment" {
  description = "(Optional) If true, Azure Resource Manager is permitted to retrieve secrets from the Key Vault. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "rbac_authorization_enabled" {
  description = "(Optional) If true, the Key Vault will use Role Based Access Control (RBAC) for authorization of data actions. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "public_network_access_enabled" {
  description = "(Optional) If true, public network access is enabled for this Key Vault. Default: true"
  type        = bool
  default     = true
  nullable    = false
}

# ========================================
# Enhanced Network ACLs Variables
# ========================================

variable "network_acls_ip_rules" {
  description = "(Optional) List of IP addresses or CIDR blocks which should be able to access the Key Vault. Example: ['203.0.113.0/24', '198.51.100.42']"
  type        = list(string)
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for ip in var.network_acls_ip_rules : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(/[0-9]{1,2})?$", ip))])
    error_message = "All IP rules must be valid IPv4 addresses or CIDR blocks."
  }
}

variable "network_acls_virtual_network_subnet_ids" {
  description = "(Optional) List of subnet IDs which should be able to access this Key Vault. Example: ['/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx']"
  type        = list(string)
  default     = []
  nullable    = false
}

# ========================================
# Access Policy Variables
# ========================================

variable "create_default_access_policy" {
  description = "(Optional) If true, creates a default access policy for the current user/service principal. Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "storage_permissions" {
  description = "(Optional) Storage permissions for the default access policy. Default: []"
  type        = list(string)
  default     = []
  nullable    = false

  validation {
    condition = alltrue([
      for perm in var.storage_permissions :
      contains([
        "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List",
        "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore",
        "Set", "SetSAS", "Update"
      ], perm)
    ])
    error_message = "Storage permissions must be valid values: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS, Update."
  }
}

variable "additional_access_policies" {
  description = <<-EOT
    (Optional) List of additional access policies for the Key Vault. Each policy should contain:
    - tenant_id: (Required) Azure AD tenant ID
    - object_id: (Required) Azure AD object ID of a user, service principal, or security group
    - application_id: (Optional) Application ID of the Azure AD application
    - key_permissions: (Optional) List of key permissions
    - secret_permissions: (Optional) List of secret permissions
    - certificate_permissions: (Optional) List of certificate permissions
    - storage_permissions: (Optional) List of storage permissions
  EOT
  type = list(object({
    tenant_id               = string
    object_id               = string
    application_id          = optional(string)
    key_permissions         = optional(list(string), [])
    secret_permissions      = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  default  = []
  nullable = false
}

# ========================================
# Contact Variables
# ========================================

variable "contacts" {
  description = <<-EOT
    (Optional) List of contact information blocks for the Key Vault. Used for certificate notifications. Each contact should contain:
    - email: (Required) Email address of the contact
    - name: (Optional) Name of the contact
    - phone: (Optional) Phone number of the contact
  EOT
  type = list(object({
    email = string
    name  = optional(string)
    phone = optional(string)
  }))
  default  = []
  nullable = false

  validation {
    condition     = alltrue([for contact in var.contacts : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", contact.email))])
    error_message = "All contact emails must be valid email addresses."
  }
}
