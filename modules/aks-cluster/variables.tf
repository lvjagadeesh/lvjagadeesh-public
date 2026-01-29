variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27.0"
}

variable "default_node_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "default"
}

variable "default_node_pool_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 3
}

variable "default_node_pool_vm_size" {
  description = "VM size for the default node pool"
  type        = string
  default     = "Standard_D2_v2"
}

variable "enable_auto_scaling" {
  description = "Enable auto-scaling for the default node pool"
  type        = bool
  default     = true
}

variable "min_node_count" {
  description = "Minimum node count for auto-scaling"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum node count for auto-scaling"
  type        = number
  default     = 5
}

variable "network_plugin" {
  description = "Network plugin to use"
  type        = string
  default     = "azure"
}

variable "load_balancer_sku" {
  description = "Load balancer SKU"
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Tags to apply to the AKS cluster"
  type        = map(string)
  default     = {}
}
