terraform {
  required_version = ">= 1.14.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.58"
    }
  }

  # Backend configuration should be provided via:
  # 1. Backend config file: terraform init -backend-config=backend.hcl
  # 2. Command line: terraform init -backend-config="key=value"
  # 3. Environment variables: TF_CLI_ARGS_init="-backend-config=..."
  backend "azurerm" {
    # These values are placeholders - override during terraform init
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

# Resource Group Module - Independent, can create multiple resource groups
module "resource_group" {
  source   = "./modules/resource-group"
  for_each = var.resource_groups

  resource_group_name = each.value.name
  location            = each.value.location
  tags                = merge(var.common_tags, lookup(each.value, "tags", {}))
}

# Virtual Network Module - Independent, requires resource_group_name as input
module "virtual_network" {
  source   = "./modules/virtual-network"
  for_each = var.virtual_networks

  vnet_name           = each.value.name
  address_space       = each.value.address_space
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnets             = lookup(each.value, "subnets", [])
  tags                = merge(var.common_tags, lookup(each.value, "tags", {}))
}

# Storage Account Module - Independent
module "storage_account" {
  source   = "./modules/storage-account"
  for_each = var.storage_accounts

  storage_account_name     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = lookup(each.value, "account_tier", "Standard")
  account_replication_type = lookup(each.value, "account_replication_type", "LRS")
  tags                     = merge(var.common_tags, lookup(each.value, "tags", {}))
}

# Key Vault Module - Independent
module "key_vault" {
  source   = "./modules/key-vault"
  for_each = var.key_vaults

  key_vault_name      = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = merge(var.common_tags, lookup(each.value, "tags", {}))
}

# App Service Plan Module - Independent
module "app_service_plan" {
  source   = "./modules/app-service-plan"
  for_each = var.app_service_plans

  app_service_plan_name = each.value.name
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  os_type               = lookup(each.value, "os_type", "Linux")
  sku_name              = lookup(each.value, "sku_name", "P1v2")
  tags                  = merge(var.common_tags, lookup(each.value, "tags", {}))
}

# App Service Module - Independent, requires service_plan_id as input
module "app_service" {
  source   = "./modules/app-service"
  for_each = var.app_services

  app_service_name    = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  service_plan_id     = each.value.service_plan_id
  tags                = merge(var.common_tags, lookup(each.value, "tags", {}))
}

# SQL Server Module - Independent
module "sql_server" {
  source   = "./modules/sql-server"
  for_each = var.sql_servers

  sql_server_name              = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_login_password
  tags                         = merge(var.common_tags, lookup(each.value, "tags", {}))
}

# SQL Database Module - Independent, requires sql_server_id as input
module "sql_database" {
  source   = "./modules/sql-database"
  for_each = var.sql_databases

  database_name = each.value.name
  sql_server_id = each.value.sql_server_id
  tags          = merge(var.common_tags, lookup(each.value, "tags", {}))
}

# Container Registry Module - Independent
module "container_registry" {
  source   = "./modules/container-registry"
  for_each = var.container_registries

  container_registry_name = each.value.name
  resource_group_name     = each.value.resource_group_name
  location                = each.value.location
  sku                     = lookup(each.value, "sku", "Standard")
  tags                    = merge(var.common_tags, lookup(each.value, "tags", {}))
}

# AKS Cluster Module - Independent
module "aks_cluster" {
  source   = "./modules/aks-cluster"
  for_each = var.aks_clusters

  cluster_name              = each.value.name
  location                  = each.value.location
  resource_group_name       = each.value.resource_group_name
  dns_prefix                = each.value.dns_prefix
  kubernetes_version        = lookup(each.value, "kubernetes_version", "1.27.0")
  default_node_pool_vm_size = lookup(each.value, "default_node_pool_vm_size", "Standard_D2_v2")
  default_node_pool_count   = lookup(each.value, "default_node_pool_count", 3)
  tags                      = merge(var.common_tags, lookup(each.value, "tags", {}))
}
