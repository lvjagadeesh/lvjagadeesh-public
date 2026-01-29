variable "cluster_name" {
  description = "(Required) Name of the AKS cluster. Must be unique within the resource group"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,63}$", var.cluster_name))
    error_message = "Cluster name must be 1-63 characters, alphanumeric and hyphens only."
  }
}

variable "location" {
  description = "(Required) Azure region where the AKS cluster will be created"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must be specified."
  }
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where the AKS cluster will be created"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "dns_prefix" {
  description = "(Required) DNS prefix for the AKS cluster. Must be unique"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,54}$", var.dns_prefix))
    error_message = "DNS prefix must be 1-54 characters, alphanumeric and hyphens only."
  }
}

variable "kubernetes_version" {
  description = "(Optional) Kubernetes version (e.g., 1.27.0, 1.28.0). Default: 1.27.0"
  type        = string
  default     = "1.27.0"
  nullable    = false

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.kubernetes_version))
    error_message = "Kubernetes version must be in semantic version format (e.g., 1.27.0)."
  }
}

variable "default_node_pool_name" {
  description = "(Optional) Name of the default node pool. Default: default"
  type        = string
  default     = "default"
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9]{1,12}$", var.default_node_pool_name))
    error_message = "Node pool name must be 1-12 characters, lowercase alphanumeric only."
  }
}

variable "default_node_pool_count" {
  description = "(Optional) Initial number of nodes in the default node pool. Default: 3"
  type        = number
  default     = 3
  nullable    = false

  validation {
    condition     = var.default_node_pool_count >= 1 && var.default_node_pool_count <= 1000
    error_message = "Node pool count must be between 1 and 1000."
  }
}

variable "default_node_pool_vm_size" {
  description = "(Optional) VM size for nodes in the default pool (e.g., Standard_D2_v2, Standard_D4_v3). Default: Standard_D2_v2"
  type        = string
  default     = "Standard_D2_v2"
  nullable    = false

  validation {
    condition     = length(var.default_node_pool_vm_size) > 0
    error_message = "VM size must be specified."
  }
}

variable "enable_auto_scaling" {
  description = "(Optional) Enable auto-scaling for the default node pool. Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "min_node_count" {
  description = "(Optional) Minimum node count when auto-scaling is enabled. Default: 1"
  type        = number
  default     = 1
  nullable    = false

  validation {
    condition     = var.min_node_count >= 1
    error_message = "Minimum node count must be at least 1."
  }
}

variable "max_node_count" {
  description = "(Optional) Maximum node count when auto-scaling is enabled. Default: 5"
  type        = number
  default     = 5
  nullable    = false

  validation {
    condition     = var.max_node_count >= 1 && var.max_node_count <= 1000
    error_message = "Maximum node count must be between 1 and 1000."
  }
}

variable "network_plugin" {
  description = "(Optional) Network plugin to use. Valid values: azure, kubenet, none. Default: azure"
  type        = string
  default     = "azure"
  nullable    = false

  validation {
    condition     = contains(["azure", "kubenet", "none"], var.network_plugin)
    error_message = "Network plugin must be one of: azure, kubenet, none."
  }
}

variable "load_balancer_sku" {
  description = "(Optional) Load balancer SKU. Valid values: basic, standard. Default: standard"
  type        = string
  default     = "standard"
  nullable    = false

  validation {
    condition     = contains(["basic", "standard"], var.load_balancer_sku)
    error_message = "Load balancer SKU must be either basic or standard."
  }
}

variable "tags" {
  description = "(Optional) Tags to apply to the AKS cluster"
  type        = map(string)
  default     = {}
  nullable    = false
}
