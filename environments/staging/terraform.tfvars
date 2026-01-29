# Staging Environment Configuration
location            = "East US"
resource_group_name = "staging-rg"

# Virtual Network
vnet_name          = "staging-vnet"
vnet_address_space = ["10.1.0.0/16"]
subnets = [
  {
    name             = "staging-subnet-1"
    address_prefixes = ["10.1.1.0/24"]
  },
  {
    name             = "staging-subnet-2"
    address_prefixes = ["10.1.2.0/24"]
  }
]

# Storage Account
storage_account_name             = "stagingstorageacct001"
storage_account_tier             = "Standard"
storage_account_replication_type = "GRS"

# Key Vault
key_vault_name = "staging-kv-001"

# App Service Plan
app_service_plan_name     = "staging-asp"
app_service_plan_os_type  = "Linux"
app_service_plan_sku_name = "S1"

# App Service
app_service_name = "staging-app-001"

# SQL Server
sql_server_name            = "staging-sqlserver-001"
sql_administrator_login    = "sqladmin"
sql_administrator_password = "REPLACE_WITH_SECURE_PASSWORD" # Use Azure Key Vault or GitHub Secrets

# SQL Database
sql_database_name = "staging-db"

# Container Registry
container_registry_name = "stagingacr001"
container_registry_sku  = "Standard"

# AKS Cluster
aks_cluster_name       = "staging-aks"
aks_dns_prefix         = "staging-aks"
aks_kubernetes_version = "1.27.0"
aks_node_pool_vm_size  = "Standard_D2_v2"
aks_node_pool_count    = 2

# Common Tags
tags = {
  Environment = "Staging"
  ManagedBy   = "Terraform"
  Project     = "Azure Infrastructure"
  CostCenter  = "Engineering"
}
