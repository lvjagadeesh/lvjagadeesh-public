# Resource Group Outputs
output "resource_groups" {
  description = "Map of all resource groups created"
  value       = module.resource_group.resource_groups
}

# Virtual Network Outputs
output "virtual_networks" {
  description = "Map of all virtual networks created"
  value = {
    for k, vnet_id in module.virtual_network.vnet_ids : k => {
      id         = vnet_id
      name       = module.virtual_network.vnet_names[k]
      subnet_ids = try(module.virtual_network.subnets_by_vnet[k], {})
    }
  }
}

# Storage Account Outputs
output "storage_accounts" {
  description = "Map of all storage accounts created"
  value       = module.storage_account.storage_accounts
}

# Key Vault Outputs
output "key_vaults" {
  description = "Map of all key vaults created"
  value = {
    for k, kv_id in module.key_vault.key_vault_ids : k => {
      id   = kv_id
      name = module.key_vault.key_vault_names[k]
      uri  = module.key_vault.key_vault_uris[k]
    }
  }
}

# App Service Plan Outputs
output "app_service_plans" {
  description = "Map of all app service plans created"
  value       = module.app_service_plan.app_service_plans
}

# App Service Outputs
output "app_services" {
  description = "Map of all app services created"
  value = {
    for k, as_id in module.app_service.app_service_ids : k => {
      id               = as_id
      name             = module.app_service.app_service_names[k]
      default_hostname = module.app_service.default_hostnames[k]
    }
  }
}

# SQL Server Outputs
output "sql_servers" {
  description = "Map of all SQL servers created"
  value = {
    for k, sql_id in module.sql_server.sql_server_ids : k => {
      id   = sql_id
      name = module.sql_server.sql_server_names[k]
      fqdn = module.sql_server.sql_server_fqdns[k]
    }
  }
}

# SQL Database Outputs
output "sql_databases" {
  description = "Map of all SQL databases created"
  value = {
    for k, db_id in module.sql_database.database_ids : k => {
      id   = db_id
      name = module.sql_database.database_names[k]
    }
  }
}

# Container Registry Outputs
output "container_registries" {
  description = "Map of all container registries created"
  value = {
    for k, acr_id in module.container_registry.container_registry_ids : k => {
      id           = acr_id
      name         = module.container_registry.container_registry_names[k]
      login_server = module.container_registry.login_servers[k]
    }
  }
}

# AKS Cluster Outputs
output "aks_clusters" {
  description = "Map of all AKS clusters created"
  value = {
    for k, cluster_id in module.aks_cluster.cluster_ids : k => {
      id   = cluster_id
      name = module.aks_cluster.cluster_names[k]
      fqdn = module.aks_cluster.fqdns[k]
    }
  }
}
