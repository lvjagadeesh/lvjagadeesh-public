# Production Environment Configuration
location            = "East US"
resource_group_name = "prod-rg"

# Virtual Network
vnet_name          = "prod-vnet"
vnet_address_space = ["10.2.0.0/16"]
subnets = [
  {
    name             = "prod-subnet-1"
    address_prefixes = ["10.2.1.0/24"]
  },
  {
    name             = "prod-subnet-2"
    address_prefixes = ["10.2.2.0/24"]
  },
  {
    name             = "prod-subnet-3"
    address_prefixes = ["10.2.3.0/24"]
  }
]

# Storage Account
storage_account_name             = "prodstorageacct001"
storage_account_tier             = "Standard"
storage_account_replication_type = "GRS"

# Key Vault
key_vault_name = "prod-kv-001"

# App Service Plan
app_service_plan_name     = "prod-asp"
app_service_plan_os_type  = "Linux"
app_service_plan_sku_name = "P1v2"

# App Service
app_service_name = "prod-app-001"

# SQL Server
sql_server_name            = "prod-sqlserver-001"
sql_administrator_login    = "sqladmin"
sql_administrator_password = "ChangeMeInProduction123!"

# SQL Database
sql_database_name = "prod-db"

# Container Registry
container_registry_name = "prodacr001"
container_registry_sku  = "Premium"

# AKS Cluster
aks_cluster_name       = "prod-aks"
aks_dns_prefix         = "prod-aks"
aks_kubernetes_version = "1.27.0"
aks_node_pool_vm_size  = "Standard_D4_v2"
aks_node_pool_count    = 3

# Common Tags
tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
  Project     = "Azure Infrastructure"
  CostCenter  = "Engineering"
  Compliance  = "Required"
}
