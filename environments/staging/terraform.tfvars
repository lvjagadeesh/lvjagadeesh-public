# Staging Environment Configuration
# This file uses the new for_each map-based structure for all modules

# Common Tags
common_tags = {
  Environment = "Staging"
  ManagedBy   = "Terraform"
  Project     = "Azure Infrastructure"
  CostCenter  = "Engineering"
}

# Resource Groups
resource_groups = {
  "primary" = {
    name     = "staging-rg"
    location = "East US"
    tags = {
      Purpose = "Primary staging resources"
    }
  }
}

# Virtual Networks
virtual_networks = {
  "main" = {
    name                = "staging-vnet"
    address_space       = ["10.1.0.0/16"]
    location            = "East US"
    resource_group_name = "staging-rg"
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
    tags = {
      Purpose = "Staging network"
    }
  }
}

# Storage Accounts
storage_accounts = {
  "main" = {
    name                     = "stagingstorageacct001"
    resource_group_name      = "staging-rg"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    tags = {
      Purpose = "Staging storage with geo-redundancy"
    }
  }
}

# Key Vaults
key_vaults = {
  "main" = {
    name                = "staging-kv-001"
    location            = "East US"
    resource_group_name = "staging-rg"
    sku_name            = "standard"
    tags = {
      Purpose = "Staging secrets"
    }
  }
}

# App Service Plans
app_service_plans = {
  "main" = {
    name                = "staging-asp"
    location            = "East US"
    resource_group_name = "staging-rg"
    os_type             = "Linux"
    sku_name            = "S1"
    tags = {
      Purpose = "Staging app hosting"
    }
  }
}

# App Services
app_services = {
  "main" = {
    name                = "staging-app-001"
    location            = "East US"
    resource_group_name = "staging-rg"
    service_plan_id     = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/staging-rg/providers/Microsoft.Web/serverfarms/staging-asp"
    site_config = {
      always_on = true
    }
    tags = {
      Purpose = "Staging web app"
    }
  }
}

# SQL Servers
sql_servers = {
  "main" = {
    name                         = "staging-sqlserver-001"
    resource_group_name          = "staging-rg"
    location                     = "East US"
    version                      = "12.0"
    administrator_login          = "sqladmin"
    administrator_login_password = "REPLACE_WITH_SECURE_PASSWORD" # Use Azure Key Vault or GitHub Secrets
    tags = {
      Purpose = "Staging database server"
    }
  }
}

# SQL Databases
sql_databases = {
  "main" = {
    name      = "staging-db"
    server_id = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/staging-rg/providers/Microsoft.Sql/servers/staging-sqlserver-001"
    sku_name  = "S0"
    tags = {
      Purpose = "Staging database"
    }
  }
}

# Container Registries
container_registries = {
  "main" = {
    name                = "stagingacr001"
    resource_group_name = "staging-rg"
    location            = "East US"
    sku                 = "Standard"
    admin_enabled       = true
    tags = {
      Purpose = "Staging container images"
    }
  }
}

# AKS Clusters
aks_clusters = {
  "main" = {
    name                = "staging-aks"
    location            = "East US"
    resource_group_name = "staging-rg"
    dns_prefix          = "staging-aks"
    kubernetes_version  = "1.27.0"
    default_node_pool = {
      name       = "default"
      node_count = 2
      vm_size    = "Standard_D2_v2"
    }
    tags = {
      Purpose = "Staging Kubernetes cluster"
    }
  }
}
