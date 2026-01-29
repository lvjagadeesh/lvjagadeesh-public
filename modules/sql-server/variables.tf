variable "sql_servers" {
  description = "(Required) Map of SQL servers to create. Each key is a unique identifier and value contains the SQL server configuration"
  type = map(object({
    name                         = string                    # (Required) Name of the SQL Server (1-63 chars, lowercase, numbers, hyphens)
    resource_group_name          = string                    # (Required) Name of the resource group
    location                     = string                    # (Required) Azure region for the SQL Server
    version                      = optional(string, "12.0")  # (Optional) SQL Server version: 2.0, 12.0
    administrator_login          = string                    # (Required) Administrator login name
    administrator_login_password = string                    # (Required) Administrator password (min 8 chars)
    minimum_tls_version          = optional(string, "1.2")   # (Optional) Minimum TLS version: 1.0, 1.1, 1.2
    azuread_admin_login          = optional(string)          # (Optional) Azure AD administrator login name
    azuread_admin_object_id      = optional(string)          # (Optional) Azure AD administrator object ID
    tags                         = optional(map(string), {}) # (Optional) Tags to apply to the SQL Server
  }))

  validation {
    condition     = alltrue([for s in var.sql_servers : can(regex("^[a-z0-9-]{1,63}$", s.name))])
    error_message = "All SQL Server names must be 1-63 characters, lowercase letters, numbers, and hyphens only."
  }

  validation {
    condition     = alltrue([for s in var.sql_servers : length(s.resource_group_name) > 0])
    error_message = "All SQL Servers must have a resource group name specified."
  }

  validation {
    condition     = alltrue([for s in var.sql_servers : length(s.location) > 0])
    error_message = "All SQL Servers must have a location specified."
  }

  validation {
    condition     = alltrue([for s in var.sql_servers : contains(["2.0", "12.0"], s.version)])
    error_message = "All SQL Server versions must be either 2.0 or 12.0."
  }

  validation {
    condition     = alltrue([for s in var.sql_servers : length(s.administrator_login) > 0])
    error_message = "All SQL Servers must have an administrator login specified."
  }

  validation {
    condition     = alltrue([for s in var.sql_servers : length(s.administrator_login_password) >= 8])
    error_message = "All SQL Server administrator passwords must be at least 8 characters long."
  }

  validation {
    condition     = alltrue([for s in var.sql_servers : contains(["1.0", "1.1", "1.2"], s.minimum_tls_version)])
    error_message = "All SQL Server minimum TLS versions must be one of: 1.0, 1.1, 1.2."
  }
}
