variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "Storage account kind"
  type        = string
  default     = "StorageV2"
}

variable "access_tier" {
  description = "Access tier for BlobStorage and StorageV2"
  type        = string
  default     = "Hot"
}

variable "min_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "blob_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 7
}

variable "network_rules_default_action" {
  description = "Default action for network rules"
  type        = string
  default     = "Deny"
}

variable "network_rules_bypass" {
  description = "Bypass network rules for services"
  type        = list(string)
  default     = ["AzureServices"]
}

variable "tags" {
  description = "Tags to apply to the storage account"
  type        = map(string)
  default     = {}
}
