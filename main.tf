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
  source = "./modules/resource-group"

  resource_groups = var.resource_groups
}

# Virtual Network Module - Depends on Resource Groups
# Virtual networks reference resource groups by name, so RGs must exist first
module "virtual_network" {
  source = "./modules/virtual-network"

  virtual_networks = var.virtual_networks

  depends_on = [module.resource_group]
}

# Storage Account Module - Depends on Resource Groups
# Storage accounts are created within resource groups
module "storage_account" {
  source = "./modules/storage-account"

  storage_accounts = var.storage_accounts

  depends_on = [module.resource_group]
}

# Key Vault Module - Depends on Resource Groups
# Key vaults are created within resource groups
module "key_vault" {
  source = "./modules/key-vault"

  key_vaults = var.key_vaults

  depends_on = [module.resource_group]
}

# App Service Plan Module - Depends on Resource Groups
# App service plans are created within resource groups
module "app_service_plan" {
  source = "./modules/app-service-plan"

  app_service_plans = var.app_service_plans

  depends_on = [module.resource_group]
}

# App Service Module - Depends on App Service Plans and Resource Groups
# App services require the service plan to exist first
module "app_service" {
  source = "./modules/app-service"

  app_services = var.app_services

  depends_on = [
    module.resource_group,
    module.app_service_plan
  ]
}

# SQL Server Module - Depends on Resource Groups
# SQL servers are created within resource groups
module "sql_server" {
  source = "./modules/sql-server"

  sql_servers = var.sql_servers

  depends_on = [module.resource_group]
}

# SQL Database Module - Depends on SQL Servers
# Databases must be created after the SQL server exists
module "sql_database" {
  source = "./modules/sql-database"

  sql_databases = var.sql_databases

  depends_on = [module.sql_server]
}

# Container Registry Module - Depends on Resource Groups
# Container registries are created within resource groups
module "container_registry" {
  source = "./modules/container-registry"

  container_registries = var.container_registries

  depends_on = [module.resource_group]
}

# AKS Cluster Module - Depends on Resource Groups and Virtual Networks
# AKS clusters need resource groups and often use VNet subnets
module "aks_cluster" {
  source = "./modules/aks-cluster"

  aks_clusters = var.aks_clusters

  depends_on = [
    module.resource_group,
    module.virtual_network
  ]
}
