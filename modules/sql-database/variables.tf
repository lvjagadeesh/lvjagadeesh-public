variable "database_name" {
  description = "Name of the SQL Database"
  type        = string
}

variable "sql_server_id" {
  description = "ID of the SQL Server"
  type        = string
}

variable "collation" {
  description = "Database collation"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "license_type" {
  description = "License type for the database"
  type        = string
  default     = "LicenseIncluded"
}

variable "max_size_gb" {
  description = "Maximum size of the database in GB"
  type        = number
  default     = 2
}

variable "sku_name" {
  description = "SKU name for the database"
  type        = string
  default     = "S0"
}

variable "zone_redundant" {
  description = "Enable zone redundancy"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the SQL Database"
  type        = map(string)
  default     = {}
}
