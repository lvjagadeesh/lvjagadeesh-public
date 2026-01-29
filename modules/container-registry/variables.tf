variable "container_registry_name" {
  description = "Name of the Container Registry"
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

variable "sku" {
  description = "SKU for the Container Registry"
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Enable admin user"
  type        = bool
  default     = false
}

variable "georeplications" {
  description = "Geo-replications for the registry"
  type = list(object({
    location                = string
    zone_redundancy_enabled = bool
    tags                    = map(string)
  }))
  default = []
}

variable "network_rule_default_action" {
  description = "Default action for network rules"
  type        = string
  default     = "Allow"
}

variable "tags" {
  description = "Tags to apply to the Container Registry"
  type        = map(string)
  default     = {}
}
