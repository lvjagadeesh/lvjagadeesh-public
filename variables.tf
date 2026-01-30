# Common Variables
variable "common_tags" {
  description = "(Optional) Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

# Resource Group Variables - for_each map
variable "resource_groups" {
  description = "(Optional) Map of resource groups to create. Each key is a unique identifier."
  type = map(object({
    name     = string                # (Required) Name of the resource group
    location = string                # (Required) Azure region
    tags     = optional(map(string)) # (Optional) Additional tags
  }))
  default = {}
}

# Virtual Network Variables - for_each map
variable "virtual_networks" {
  description = "(Optional) Map of virtual networks to create. Each key is a unique identifier."
  type = map(object({
    name                = string       # (Required) Name of the virtual network
    address_space       = list(string) # (Required) Address space
    location            = string       # (Required) Azure region
    resource_group_name = string       # (Required) Resource group name
    subnets = optional(list(object({   # (Optional) List of subnets
      name             = string
      address_prefixes = list(string)
    })), [])
    tags = optional(map(string)) # (Optional) Additional tags
  }))
  default = {}
}

# Storage Account Variables - for_each map
variable "storage_accounts" {
  description = "(Optional) Map of storage accounts to create. Each key is a unique identifier."
  type = map(object({
    name                     = string                # (Required) Storage account name
    resource_group_name      = string                # (Required) Resource group name
    location                 = string                # (Required) Azure region
    account_tier             = optional(string)      # (Optional) Account tier, default: Standard
    account_replication_type = optional(string)      # (Optional) Replication type, default: LRS
    tags                     = optional(map(string)) # (Optional) Additional tags
  }))
  default = {}
}

# Key Vault Variables - for_each map
variable "key_vaults" {
  description = "(Optional) Map of key vaults to create. Each key is a unique identifier."
  type = map(object({
    name                = string                # (Required) Key Vault name
    location            = string                # (Required) Azure region
    resource_group_name = string                # (Required) Resource group name
    tags                = optional(map(string)) # (Optional) Additional tags
  }))
  default = {}
}

# App Service Plan Variables - for_each map
variable "app_service_plans" {
  description = "(Optional) Map of app service plans to create. Each key is a unique identifier."
  type = map(object({
    name                         = string                # (Required) App Service Plan name
    location                     = string                # (Required) Azure region
    resource_group_name          = string                # (Required) Resource group name
    os_type                      = optional(string)      # (Optional) OS type, default: Linux
    sku_name                     = optional(string)      # (Optional) SKU name, default: P1v2
    app_service_environment_id   = optional(string)      # (Optional) App Service Environment ID
    maximum_elastic_worker_count = optional(number)      # (Optional) Max elastic workers
    worker_count                 = optional(number)      # (Optional) Number of workers
    per_site_scaling_enabled     = optional(bool)        # (Optional) Per-site scaling
    zone_balancing_enabled       = optional(bool)        # (Optional) Zone balancing
    tags                         = optional(map(string)) # (Optional) Additional tags
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
  }))
  default = {}
}

# App Service Variables - for_each map
variable "app_services" {
  description = "(Optional) Map of app services to create. Each key is a unique identifier."
  type = map(object({
    name                = string                # (Required) App Service name
    location            = string                # (Required) Azure region
    resource_group_name = string                # (Required) Resource group name
    service_plan_id     = string                # (Required) Service Plan ID
    tags                = optional(map(string)) # (Optional) Additional tags
  }))
  default = {}
}

# SQL Server Variables - for_each map
variable "sql_servers" {
  description = "(Optional) Map of SQL servers to create. Each key is a unique identifier."
  type = map(object({
    name                         = string                # (Required) SQL Server name
    resource_group_name          = string                # (Required) Resource group name
    location                     = string                # (Required) Azure region
    administrator_login          = string                # (Required) Admin login
    administrator_login_password = string                # (Required) Admin password
    tags                         = optional(map(string)) # (Optional) Additional tags
  }))
  default = {}
  # Note: Passwords should be managed securely via environment variables or external systems
}

# SQL Database Variables - for_each map
variable "sql_databases" {
  description = "(Optional) Map of SQL databases to create. Each key is a unique identifier."
  type = map(object({
    name      = string                # (Required) Database name
    server_id = string                # (Required) SQL Server ID
    tags      = optional(map(string)) # (Optional) Additional tags
  }))
  default = {}
}

# Container Registry Variables - for_each map
variable "container_registries" {
  description = "(Optional) Map of container registries to create. Each key is a unique identifier."
  type = map(object({
    name                = string                # (Required) Container Registry name
    resource_group_name = string                # (Required) Resource group name
    location            = string                # (Required) Azure region
    sku                 = optional(string)      # (Optional) SKU, default: Standard
    tags                = optional(map(string)) # (Optional) Additional tags
  }))
  default = {}
}

# AKS Cluster Variables - for_each map
variable "aks_clusters" {
  description = "(Optional) Map of AKS clusters to create. Each key is a unique identifier."
  type = map(object({
    cluster_name              = string                # (Required) AKS cluster name
    location                  = string                # (Required) Azure region
    resource_group_name       = string                # (Required) Resource group name
    dns_prefix                = string                # (Required) DNS prefix
    kubernetes_version        = optional(string)      # (Optional) K8s version, default: 1.27.0
    default_node_pool_vm_size = optional(string)      # (Optional) VM size, default: Standard_D2_v2
    default_node_pool_count   = optional(number)      # (Optional) Node count, default: 3
    tags                      = optional(map(string)) # (Optional) Additional tags
  }))
  default = {}
}
