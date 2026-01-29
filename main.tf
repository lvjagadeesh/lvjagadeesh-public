terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestore"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

# Resource Group Module
module "resource_group" {
  source = "./modules/resource-group"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Virtual Network Module
module "virtual_network" {
  source = "./modules/virtual-network"

  vnet_name           = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  subnets             = var.subnets
  tags                = var.tags

  depends_on = [module.resource_group]
}

# Storage Account Module
module "storage_account" {
  source = "./modules/storage-account"

  storage_account_name         = var.storage_account_name
  resource_group_name          = module.resource_group.resource_group_name
  location                     = var.location
  account_tier                 = var.storage_account_tier
  account_replication_type     = var.storage_account_replication_type
  tags                         = var.tags

  depends_on = [module.resource_group]
}

# Key Vault Module
module "key_vault" {
  source = "./modules/key-vault"

  key_vault_name      = var.key_vault_name
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  tags                = var.tags

  depends_on = [module.resource_group]
}

# App Service Plan Module
module "app_service_plan" {
  source = "./modules/app-service-plan"

  app_service_plan_name = var.app_service_plan_name
  location              = var.location
  resource_group_name   = module.resource_group.resource_group_name
  os_type               = var.app_service_plan_os_type
  sku_name              = var.app_service_plan_sku_name
  tags                  = var.tags

  depends_on = [module.resource_group]
}

# App Service Module
module "app_service" {
  source = "./modules/app-service"

  app_service_name    = var.app_service_name
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  service_plan_id     = module.app_service_plan.app_service_plan_id
  tags                = var.tags

  depends_on = [module.app_service_plan]
}

# SQL Server Module
module "sql_server" {
  source = "./modules/sql-server"

  sql_server_name              = var.sql_server_name
  resource_group_name          = module.resource_group.resource_group_name
  location                     = var.location
  administrator_login          = var.sql_administrator_login
  administrator_login_password = var.sql_administrator_password
  tags                         = var.tags

  depends_on = [module.resource_group]
}

# SQL Database Module
module "sql_database" {
  source = "./modules/sql-database"

  database_name = var.sql_database_name
  sql_server_id = module.sql_server.sql_server_id
  tags          = var.tags

  depends_on = [module.sql_server]
}

# Container Registry Module
module "container_registry" {
  source = "./modules/container-registry"

  container_registry_name = var.container_registry_name
  resource_group_name     = module.resource_group.resource_group_name
  location                = var.location
  sku                     = var.container_registry_sku
  tags                    = var.tags

  depends_on = [module.resource_group]
}

# AKS Cluster Module
module "aks_cluster" {
  source = "./modules/aks-cluster"

  cluster_name               = var.aks_cluster_name
  location                   = var.location
  resource_group_name        = module.resource_group.resource_group_name
  dns_prefix                 = var.aks_dns_prefix
  kubernetes_version         = var.aks_kubernetes_version
  default_node_pool_vm_size  = var.aks_node_pool_vm_size
  default_node_pool_count    = var.aks_node_pool_count
  tags                       = var.tags

  depends_on = [module.resource_group]
}
