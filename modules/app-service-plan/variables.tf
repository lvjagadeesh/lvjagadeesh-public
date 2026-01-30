variable "app_service_plans" {
  description = "(Required) Map of App Service Plans to create. Each key is a unique identifier and value contains the App Service Plan configuration"
  type = map(object({
    name                         = string                    # (Required) Name of the App Service Plan (1-60 chars)
    location                     = string                    # (Required) Azure region where the App Service Plan will be created
    resource_group_name          = string                    # (Required) Name of the resource group
    os_type                      = optional(string, "Linux") # (Optional) OS type: Linux, Windows, WindowsContainer
    sku_name                     = optional(string, "P1v2")  # (Optional) SKU name (e.g., B1, P1v2, P1v3, etc.)
    app_service_environment_id   = optional(string)          # (Optional) ID of the App Service Environment
    maximum_elastic_worker_count = optional(number)          # (Optional) Max workers for Elastic SKU
    worker_count                 = optional(number)          # (Optional) Number of workers (1-30)
    per_site_scaling_enabled     = optional(bool, false)     # (Optional) Enable per-site scaling
    zone_balancing_enabled       = optional(bool, false)     # (Optional) Enable zone balancing
    tags                         = optional(map(string), {}) # (Optional) Tags to assign
    timeouts = optional(object({
      create = optional(string, "60m")
      read   = optional(string, "5m")
      update = optional(string, "60m")
      delete = optional(string, "60m")
    }))
  }))

  validation {
    condition     = alltrue([for asp in var.app_service_plans : length(asp.name) > 0 && length(asp.name) <= 60])
    error_message = "All App Service Plan names must be between 1 and 60 characters."
  }

  validation {
    condition     = alltrue([for asp in var.app_service_plans : length(asp.location) > 0])
    error_message = "All App Service Plans must have a location specified."
  }

  validation {
    condition     = alltrue([for asp in var.app_service_plans : length(asp.resource_group_name) > 0])
    error_message = "All App Service Plans must have a resource group name specified."
  }

  validation {
    condition     = alltrue([for asp in var.app_service_plans : contains(["Linux", "Windows", "WindowsContainer"], asp.os_type)])
    error_message = "All App Service Plan OS types must be one of: Linux, Windows, WindowsContainer."
  }

  validation {
    condition     = alltrue([for asp in var.app_service_plans : length(asp.sku_name) > 0])
    error_message = "All App Service Plans must have a SKU name specified."
  }

  validation {
    condition     = alltrue([for asp in var.app_service_plans : asp.maximum_elastic_worker_count == null || asp.maximum_elastic_worker_count >= 0])
    error_message = "All App Service Plan maximum elastic worker counts must be a positive number or null."
  }

  validation {
    condition     = alltrue([for asp in var.app_service_plans : asp.worker_count == null || (asp.worker_count >= 1 && asp.worker_count <= 30)])
    error_message = "All App Service Plan worker counts must be between 1 and 30, or null."
  }
}
