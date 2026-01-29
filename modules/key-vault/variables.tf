variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku_name" {
  description = "SKU name for Key Vault"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain deleted key vaults"
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Enable purge protection"
  type        = bool
  default     = true
}

variable "network_acls_bypass" {
  description = "Bypass network ACLs for services"
  type        = string
  default     = "AzureServices"
}

variable "network_acls_default_action" {
  description = "Default action for network ACLs"
  type        = string
  default     = "Deny"
}

variable "key_permissions" {
  description = "Key permissions"
  type        = list(string)
  default     = ["Get", "List", "Create", "Delete", "Update"]
}

variable "secret_permissions" {
  description = "Secret permissions"
  type        = list(string)
  default     = ["Get", "List", "Set", "Delete"]
}

variable "certificate_permissions" {
  description = "Certificate permissions"
  type        = list(string)
  default     = ["Get", "List", "Create", "Delete"]
}

variable "tags" {
  description = "Tags to apply to the Key Vault"
  type        = map(string)
  default     = {}
}
