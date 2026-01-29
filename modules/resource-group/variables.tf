variable "resource_groups" {
  description = "(Required) Map of resource groups to create. Each key is a unique identifier and value contains the resource group configuration"
  type = map(object({
    name       = string                # (Required) Name of the resource group (1-90 characters)
    location   = string                # (Required) Azure region for the resource group
    managed_by = optional(string)      # (Optional) ID of resource/application managing this RG
    tags       = optional(map(string)) # (Optional) Tags to apply to the resource group
  }))

  validation {
    condition     = alltrue([for rg in var.resource_groups : length(rg.name) > 0 && length(rg.name) <= 90])
    error_message = "All resource group names must be between 1 and 90 characters."
  }

  validation {
    condition     = alltrue([for rg in var.resource_groups : length(rg.location) > 0])
    error_message = "All resource groups must have a location specified."
  }
}
