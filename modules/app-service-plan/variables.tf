variable "app_service_plan_name" {
  description = "(Required) Name of the App Service Plan. Must be unique within the resource group. Changing this forces a new resource to be created."
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
  description = "(Required) OS type for App Services to be hosted in the App Service Plan. Valid values: Linux, Windows, WindowsContainer. Default: Linux"
  type        = string
  default     = "Linux"
  nullable    = false

  validation {
    condition     = contains(["Linux", "Windows", "WindowsContainer"], var.os_type)
    error_message = "OS type must be one of: Linux, Windows, WindowsContainer."
  }
}

variable "sku_name" {
  description = "(Required) SKU name for the App Service Plan. Valid options include: B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, I4v2, I5v2, I6v2, P1v2, P2v2, P3v2, P0v3, P1v3, P2v3, P3v3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, P0v4, P1v4, P2v4, P3v4, P1mv4, P2mv4, P3mv4, P4mv4, P5mv4, S1, S2, S3, SHARED, EP1, EP2, EP3, FC1, WS1, WS2, WS3, Y1. Default: P1v2"
  type        = string
  default     = "P1v2"
  nullable    = false

  validation {
    condition     = length(var.sku_name) > 0
    error_message = "SKU name must be specified."
  }
}

variable "app_service_environment_id" {
  description = "(Optional) The ID of the App Service Environment to create this Service Plan in. Required if using Isolated SKUs (I1, I2, I3, etc.)"
  type        = string
  default     = null
}

variable "maximum_elastic_worker_count" {
  description = "(Optional) The maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU"
  type        = number
  default     = null

  validation {
    condition     = var.maximum_elastic_worker_count == null || var.maximum_elastic_worker_count >= 0
    error_message = "Maximum elastic worker count must be a positive number or null."
  }
}

variable "worker_count" {
  description = "(Optional) The number of Workers (instances) to be allocated"
  type        = number
  default     = null

  validation {
    condition     = var.worker_count == null || (var.worker_count >= 1 && var.worker_count <= 30)
    error_message = "Worker count must be between 1 and 30, or null."
  }
}

variable "per_site_scaling_enabled" {
  description = "(Optional) Should Per Site Scaling be enabled. Defaults to false"
  type        = bool
  default     = false
  nullable    = false
}

variable "zone_balancing_enabled" {
  description = "(Optional) Should the Service Plan balance across Availability Zones in the region. Defaults to false. Changing this forces a new resource to be created"
  type        = bool
  default     = false
  nullable    = false
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "timeouts" {
  description = "(Optional) Customizable timeout settings for create, read, update, and delete operations"
  type = object({
    create = optional(string, "60m")
    read   = optional(string, "5m")
    update = optional(string, "60m")
    delete = optional(string, "60m")
  })
  default = {
    create = "60m"
    read   = "5m"
    update = "60m"
    delete = "60m"
  }
  nullable = false
}
