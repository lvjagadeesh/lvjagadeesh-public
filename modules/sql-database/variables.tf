variable "database_name" {
  description = "(Required) Name of the SQL Database. Must be unique within the server"
  type        = string

  validation {
    condition     = length(var.database_name) > 0 && length(var.database_name) <= 128
    error_message = "Database name must be between 1 and 128 characters."
  }
}

variable "sql_server_id" {
  description = "(Required) Resource ID of the SQL Server where the database will be created"
  type        = string

  validation {
    condition     = length(var.sql_server_id) > 0
    error_message = "SQL Server ID must be specified."
  }
}

variable "collation" {
  description = "(Optional) Database collation. Default: SQL_Latin1_General_CP1_CI_AS"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
  nullable    = false
}

variable "license_type" {
  description = "(Optional) License type. Valid values: LicenseIncluded, BasePrice. Default: LicenseIncluded"
  type        = string
  default     = "LicenseIncluded"
  nullable    = false

  validation {
    condition     = contains(["LicenseIncluded", "BasePrice"], var.license_type)
    error_message = "License type must be either LicenseIncluded or BasePrice."
  }
}

variable "max_size_gb" {
  description = "(Optional) Maximum size of the database in GB. Default: 2"
  type        = number
  default     = 2
  nullable    = false

  validation {
    condition     = var.max_size_gb > 0
    error_message = "Maximum size must be greater than 0 GB."
  }
}

variable "sku_name" {
  description = "(Optional) SKU name for the database (e.g., S0, S1, P1, GP_Gen5_2). Default: S0"
  type        = string
  default     = "S0"
  nullable    = false

  validation {
    condition     = length(var.sku_name) > 0
    error_message = "SKU name must be specified."
  }
}

variable "zone_redundant" {
  description = "(Optional) Enable zone redundancy for high availability. Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "tags" {
  description = "(Optional) Tags to apply to the SQL Database"
  type        = map(string)
  default     = {}
  nullable    = false
}
