variable "app_service_name" {
  description = "(Required) Name of the App Service. Must be globally unique"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,60}$", var.app_service_name))
    error_message = "App Service name must be 1-60 characters, alphanumeric and hyphens only."
  }
}

variable "location" {
  description = "(Required) Azure region where the App Service will be created"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must be specified."
  }
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where the App Service will be created"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "service_plan_id" {
  description = "(Required) ID of the App Service Plan where the App Service will be deployed"
  type        = string

  validation {
    condition     = length(var.service_plan_id) > 0
    error_message = "Service Plan ID must be specified."
  }
}

variable "always_on" {
  description = "(Optional) Enable Always On feature to keep the app loaded. Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "docker_image_name" {
  description = "(Optional) Docker image name for containerized deployments (e.g., nginx:latest). Default: null"
  type        = string
  default     = null
}

variable "docker_registry_url" {
  description = "(Optional) Docker registry URL. Default: https://index.docker.io"
  type        = string
  default     = "https://index.docker.io"
  nullable    = false
}

variable "app_settings" {
  description = "(Optional) Application settings for the App Service as key-value pairs. Default: {}"
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "tags" {
  description = "(Optional) Tags to apply to the App Service"
  type        = map(string)
  default     = {}
  nullable    = false
}
