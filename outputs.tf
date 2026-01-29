# Resource Group Outputs
output "resource_groups" {
  description = "Map of all resource groups created"
  value = {
    for k, rg in module.resource_group : k => {
      name     = rg.resource_group_name
      id       = rg.resource_group_id
      location = rg.location
    }
  }
}

# Virtual Network Outputs
output "virtual_networks" {
  description = "Map of all virtual networks created"
  value = {
    for k, vnet in module.virtual_network : k => {
      id         = vnet.vnet_id
      name       = vnet.vnet_name
      subnet_ids = vnet.subnet_ids
    }
  }
}

# Storage Account Outputs
output "storage_accounts" {
  description = "Map of all storage accounts created"
  value = {
    for k, sa in module.storage_account : k => {
      id                   = sa.storage_account_id
      name                 = sa.storage_account_name
      primary_blob_endpoint = sa.primary_blob_endpoint
    }
  }
}

# Key Vault Outputs
output "key_vaults" {
  description = "Map of all key vaults created"
  value = {
    for k, kv in module.key_vault : k => {
      id   = kv.key_vault_id
      name = kv.key_vault_name
      uri  = kv.key_vault_uri
    }
  }
}

# App Service Plan Outputs
output "app_service_plans" {
  description = "Map of all app service plans created"
  value = {
    for k, asp in module.app_service_plan : k => {
      id   = asp.app_service_plan_id
      name = asp.app_service_plan_name
    }
  }
}

# App Service Outputs
output "app_services" {
  description = "Map of all app services created"
  value = {
    for k, as in module.app_service : k => {
      id               = as.app_service_id
      name             = as.app_service_name
      default_hostname = as.default_hostname
    }
  }
}

# SQL Server Outputs
output "sql_servers" {
  description = "Map of all SQL servers created"
  value = {
    for k, sql in module.sql_server : k => {
      id   = sql.sql_server_id
      name = sql.sql_server_name
      fqdn = sql.sql_server_fqdn
    }
  }
}

# SQL Database Outputs
output "sql_databases" {
  description = "Map of all SQL databases created"
  value = {
    for k, db in module.sql_database : k => {
      id   = db.database_id
      name = db.database_name
    }
  }
}

# Container Registry Outputs
output "container_registries" {
  description = "Map of all container registries created"
  value = {
    for k, acr in module.container_registry : k => {
      id           = acr.container_registry_id
      name         = acr.container_registry_name
      login_server = acr.login_server
    }
  }
}

# AKS Cluster Outputs
output "aks_clusters" {
  description = "Map of all AKS clusters created"
  value = {
    for k, aks in module.aks_cluster : k => {
      id   = aks.cluster_id
      name = aks.cluster_name
      fqdn = aks.cluster_fqdn
    }
  }
}
