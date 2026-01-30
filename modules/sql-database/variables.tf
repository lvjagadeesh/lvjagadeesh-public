variable "sql_databases" {
  description = "(Required) Map of SQL databases to create. Each key is a unique identifier and value contains the database configuration"
  type = map(object({
    name           = string                                           # (Required) Name of the SQL Database. Must be unique within the server
    server_id      = string                                           # (Required) Resource ID of the SQL Server where the database will be created
    collation      = optional(string, "SQL_Latin1_General_CP1_CI_AS") # (Optional) Database collation
    license_type   = optional(string, "LicenseIncluded")              # (Optional) License type. Valid values: LicenseIncluded, BasePrice
    max_size_gb    = optional(number, 2)                              # (Optional) Maximum size of the database in GB
    sku_name       = optional(string, "S0")                           # (Optional) SKU name for the database (e.g., S0, S1, P1, GP_Gen5_2)
    zone_redundant = optional(bool, false)                            # (Optional) Enable zone redundancy for high availability
    tags           = optional(map(string), {})                        # (Optional) Tags to apply to the SQL Database
  }))

  validation {
    condition     = alltrue([for db in var.sql_databases : length(db.name) > 0 && length(db.name) <= 128])
    error_message = "All database names must be between 1 and 128 characters."
  }

  validation {
    condition     = alltrue([for db in var.sql_databases : length(db.server_id) > 0])
    error_message = "All databases must have a SQL Server ID specified."
  }

  validation {
    condition     = alltrue([for db in var.sql_databases : contains(["LicenseIncluded", "BasePrice"], db.license_type)])
    error_message = "All database license types must be either LicenseIncluded or BasePrice."
  }

  validation {
    condition     = alltrue([for db in var.sql_databases : db.max_size_gb > 0])
    error_message = "All database maximum sizes must be greater than 0 GB."
  }

  validation {
    condition     = alltrue([for db in var.sql_databases : length(db.sku_name) > 0])
    error_message = "All databases must have a SKU name specified."
  }
}
