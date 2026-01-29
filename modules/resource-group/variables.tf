variable "resource_group_name" {
  description = "(Required) Name of the resource group"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters."
  }
}

variable "location" {
  description = "(Required) Azure region where the resource group will be created"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must be specified."
  }
}

variable "managed_by" {
  description = "(Optional) The ID of the resource or application that manages this Resource Group"
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) Tags to apply to the resource group"
  type        = map(string)
  default     = {}
  nullable    = false
}
