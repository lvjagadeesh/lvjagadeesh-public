# General Variables
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

# Resource Group Variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Virtual Network Variables
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name             = string
    address_prefixes = list(string)
  }))
  default = []
}

# Storage Account Variables
variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

# Key Vault Variables
variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

# App Service Plan Variables
variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "app_service_plan_os_type" {
  description = "OS type for App Service Plan"
  type        = string
  default     = "Linux"
}

variable "app_service_plan_sku_name" {
  description = "SKU name for App Service Plan"
  type        = string
  default     = "P1v2"
}

# App Service Variables
variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
}

# SQL Server Variables
variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
}

variable "sql_administrator_login" {
  description = "SQL Server administrator login"
  type        = string
}

variable "sql_administrator_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

# SQL Database Variables
variable "sql_database_name" {
  description = "Name of the SQL Database"
  type        = string
}

# Container Registry Variables
variable "container_registry_name" {
  description = "Name of the Container Registry"
  type        = string
}

variable "container_registry_sku" {
  description = "SKU for the Container Registry"
  type        = string
  default     = "Standard"
}

# AKS Cluster Variables
variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "aks_dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "aks_kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27.0"
}

variable "aks_node_pool_vm_size" {
  description = "VM size for AKS node pool"
  type        = string
  default     = "Standard_D2_v2"
}

variable "aks_node_pool_count" {
  description = "Number of nodes in AKS node pool"
  type        = number
  default     = 3
}
