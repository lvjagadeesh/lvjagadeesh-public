# Production Environment Configuration
# This file uses the new for_each map-based structure for all modules

# Common Tags
common_tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
  Project     = "Azure Infrastructure"
  CostCenter  = "Engineering"
  Compliance  = "Required"
}

# Resource Groups
resource_groups = {
  "primary" = {
    name     = "prod-rg"
    location = "East US"
    tags = {
      Purpose     = "Primary production resources"
      Criticality = "High"
    }
  }
}

# Virtual Networks
virtual_networks = {
  "main" = {
    name                = "prod-vnet"
    address_space       = ["10.2.0.0/16"]
    location            = "East US"
    resource_group_name = "prod-rg"
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
    tags = {
      Purpose     = "Production network"
      Criticality = "High"
    }
  }
}

# Storage Accounts
storage_accounts = {
  "main" = {
    name                     = "prodstorageacct001"
    resource_group_name      = "prod-rg"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    tags = {
      Purpose     = "Production storage with geo-redundancy"
      Criticality = "High"
    }
  }
}

# Key Vaults
key_vaults = {
  "main" = {
    name                = "prod-kv-001"
    location            = "East US"
    resource_group_name = "prod-rg"
    sku_name            = "premium"
    tags = {
      Purpose     = "Production secrets"
      Criticality = "Critical"
    }
  }
}

# App Service Plans
app_service_plans = {
  "main" = {
    name                   = "prod-asp"
    location               = "East US"
    resource_group_name    = "prod-rg"
    os_type                = "Linux"
    sku_name               = "P1v2"
    zone_balancing_enabled = true
    tags = {
      Purpose     = "Production app hosting"
      Criticality = "High"
    }
  }
}

# App Services
app_services = {
  "main" = {
    name                = "prod-app-001"
    location            = "East US"
    resource_group_name = "prod-rg"
    service_plan_id     = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/prod-rg/providers/Microsoft.Web/serverfarms/prod-asp"
    https_only          = true
    site_config = {
      always_on       = true
      http2_enabled   = true
      min_tls_version = "1.2"
    }
    tags = {
      Purpose     = "Production web app"
      Criticality = "High"
    }
  }
}

# SQL Servers
sql_servers = {
  "main" = {
    name                          = "prod-sqlserver-001"
    resource_group_name           = "prod-rg"
    location                      = "East US"
    version                       = "12.0"
    administrator_login           = "sqladmin"
    administrator_login_password  = "REPLACE_WITH_SECURE_PASSWORD" # Use Azure Key Vault or GitHub Secrets
    minimum_tls_version           = "1.2"
    public_network_access_enabled = false
    tags = {
      Purpose     = "Production database server"
      Criticality = "Critical"
    }
  }
}

# SQL Databases
sql_databases = {
  "main" = {
    name      = "prod-db"
    server_id = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/prod-rg/providers/Microsoft.Sql/servers/prod-sqlserver-001"
    sku_name  = "S3"
    tags = {
      Purpose     = "Production database"
      Criticality = "Critical"
    }
  }
}

# Container Registries
container_registries = {
  "main" = {
    name                          = "prodacr001"
    resource_group_name           = "prod-rg"
    location                      = "East US"
    sku                           = "Premium"
    admin_enabled                 = false
    public_network_access_enabled = false
    zone_redundancy_enabled       = true
    tags = {
      Purpose     = "Production container images"
      Criticality = "High"
    }
  }
}

# AKS Clusters
aks_clusters = {
  "main" = {
    name                = "prod-aks"
    location            = "East US"
    resource_group_name = "prod-rg"
    dns_prefix          = "prod-aks"
    kubernetes_version  = "1.27.0"
    default_node_pool = {
      name                = "default"
      node_count          = 3
      vm_size             = "Standard_D4_v2"
      enable_auto_scaling = true
      min_count           = 3
      max_count           = 10
    }
    tags = {
      Purpose     = "Production Kubernetes cluster"
      Criticality = "Critical"
    }
  }
}
