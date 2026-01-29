variable "sql_server_name" {
  description = "Name of the SQL Server"
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

variable "sql_server_version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0"
}

variable "administrator_login" {
  description = "Administrator login for the SQL Server"
  type        = string
}

variable "administrator_login_password" {
  description = "Administrator password for the SQL Server"
  type        = string
  sensitive   = true
}

variable "minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "azuread_admin_login" {
  description = "Azure AD administrator login"
  type        = string
  default     = null
}

variable "azuread_admin_object_id" {
  description = "Azure AD administrator object ID"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the SQL Server"
  type        = map(string)
  default     = {}
}
