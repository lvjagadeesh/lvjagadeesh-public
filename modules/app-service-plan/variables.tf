variable "app_service_plan_name" {
  description = "(Required) Name of the App Service Plan. Must be unique within the resource group"
  type        = string

  validation {
    condition     = length(var.app_service_plan_name) > 0 && length(var.app_service_plan_name) <= 60
    error_message = "App Service Plan name must be between 1 and 60 characters."
  }
}

variable "location" {
  description = "(Required) Azure region where the App Service Plan will be created"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must be specified."
  }
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where the App Service Plan will be created"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "os_type" {
  description = "(Optional) OS type for the App Service Plan. Valid values: Linux, Windows. Default: Linux"
  type        = string
  default     = "Linux"
  nullable    = false

  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "OS type must be either Linux or Windows."
  }
}

variable "sku_name" {
  description = "(Optional) SKU name for the App Service Plan (e.g., B1, S1, P1v2, P1v3). Default: P1v2"
  type        = string
  default     = "P1v2"
  nullable    = false

  validation {
    condition     = length(var.sku_name) > 0
    error_message = "SKU name must be specified."
  }
}

variable "tags" {
  description = "(Optional) Tags to apply to the App Service Plan"
  type        = map(string)
  default     = {}
  nullable    = false
}
