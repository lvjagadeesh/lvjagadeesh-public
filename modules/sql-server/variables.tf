variable "sql_server_name" {
  description = "(Required) Name of the SQL Server. Must be globally unique, 1-63 characters, lowercase"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,63}$", var.sql_server_name))
    error_message = "SQL Server name must be 1-63 characters, lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where the SQL Server will be created"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "location" {
  description = "(Required) Azure region where the SQL Server will be created"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must be specified."
  }
}

variable "sql_server_version" {
  description = "(Optional) SQL Server version. Valid values: 2.0, 12.0. Default: 12.0"
  type        = string
  default     = "12.0"
  nullable    = false

  validation {
    condition     = contains(["2.0", "12.0"], var.sql_server_version)
    error_message = "SQL Server version must be either 2.0 or 12.0."
  }
}

variable "administrator_login" {
  description = "(Required) Administrator login name for the SQL Server"
  type        = string

  validation {
    condition     = length(var.administrator_login) > 0
    error_message = "Administrator login must be specified."
  }
}

variable "administrator_login_password" {
  description = "(Required) Administrator password for the SQL Server. Must meet Azure complexity requirements"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.administrator_login_password) >= 8
    error_message = "Administrator password must be at least 8 characters long."
  }
}

variable "minimum_tls_version" {
  description = "(Optional) Minimum TLS version. Valid values: 1.0, 1.1, 1.2. Default: 1.2"
  type        = string
  default     = "1.2"
  nullable    = false

  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "Minimum TLS version must be one of: 1.0, 1.1, 1.2."
  }
}

variable "azuread_admin_login" {
  description = "(Optional) Azure AD administrator login name. Default: null"
  type        = string
  default     = null
}

variable "azuread_admin_object_id" {
  description = "(Optional) Azure AD administrator object ID. Default: null"
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) Tags to apply to the SQL Server"
  type        = map(string)
  default     = {}
  nullable    = false
}
