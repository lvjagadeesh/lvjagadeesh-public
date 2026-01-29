# Development Environment Configuration
location            = "East US"
resource_group_name = "dev-rg"

# Virtual Network
vnet_name         = "dev-vnet"
vnet_address_space = ["10.0.0.0/16"]
subnets = [
  {
    name             = "dev-subnet-1"
    address_prefixes = ["10.0.1.0/24"]
  },
  {
    name             = "dev-subnet-2"
    address_prefixes = ["10.0.2.0/24"]
  }
]

# Storage Account
storage_account_name             = "devstorageacct001"
storage_account_tier             = "Standard"
storage_account_replication_type = "LRS"

# Key Vault
key_vault_name = "dev-kv-001"

# App Service Plan
app_service_plan_name     = "dev-asp"
app_service_plan_os_type  = "Linux"
app_service_plan_sku_name = "B1"

# App Service
app_service_name = "dev-app-001"

# SQL Server
sql_server_name          = "dev-sqlserver-001"
sql_administrator_login  = "sqladmin"
sql_administrator_password = "ChangeMeInProduction123!"

# SQL Database
sql_database_name = "dev-db"

# Container Registry
container_registry_name = "devacr001"
container_registry_sku  = "Basic"

# AKS Cluster
aks_cluster_name        = "dev-aks"
aks_dns_prefix          = "dev-aks"
aks_kubernetes_version  = "1.27.0"
aks_node_pool_vm_size   = "Standard_B2s"
aks_node_pool_count     = 1

# Common Tags
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
  Project     = "Azure Infrastructure"
  CostCenter  = "Engineering"
}
