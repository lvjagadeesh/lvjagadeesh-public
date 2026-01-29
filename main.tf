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

# Virtual Network Module - Independent, requires resource_group_name as input
module "virtual_network" {
  source = "./modules/virtual-network"

  virtual_networks = var.virtual_networks
}

# Storage Account Module - Independent
module "storage_account" {
  source = "./modules/storage-account"

  storage_accounts = var.storage_accounts
}

# Key Vault Module - Independent
module "key_vault" {
  source = "./modules/key-vault"

  key_vaults = var.key_vaults
}

# App Service Plan Module - Independent
module "app_service_plan" {
  source = "./modules/app-service-plan"

  app_service_plans = var.app_service_plans
}

# App Service Module - Independent, requires service_plan_id as input
module "app_service" {
  source = "./modules/app-service"

  app_services = var.app_services
}

# SQL Server Module - Independent
module "sql_server" {
  source = "./modules/sql-server"

  sql_servers = var.sql_servers
}

# SQL Database Module - Independent, requires sql_server_id as input
module "sql_database" {
  source = "./modules/sql-database"

  sql_databases = var.sql_databases
}

# Container Registry Module - Independent
module "container_registry" {
  source = "./modules/container-registry"

  container_registries = var.container_registries
}

# AKS Cluster Module - Independent
module "aks_cluster" {
  source = "./modules/aks-cluster"

  aks_clusters = var.aks_clusters
}
