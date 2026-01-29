# Development Environment Configuration
# This file uses the new for_each map-based structure for all modules

# Common Tags
common_tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
  Project     = "Azure Infrastructure"
  CostCenter  = "Engineering"
}

# Resource Groups
resource_groups = {
  "primary" = {
    name     = "dev-rg"
    location = "East US"
    tags = {
      Purpose = "Primary development resources"
    }
  }
}

# Virtual Networks
virtual_networks = {
  "main" = {
    name                = "dev-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "East US"
    resource_group_name = "dev-rg"
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
    tags = {
      Purpose = "Development network"
    }
  }
}

# Storage Accounts
storage_accounts = {
  "main" = {
    name                     = "devstorageacct001"
    resource_group_name      = "dev-rg"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    tags = {
      Purpose = "Development storage"
    }
  }
}

# Key Vaults
key_vaults = {
  "main" = {
    name                = "dev-kv-001"
    location            = "East US"
    resource_group_name = "dev-rg"
    sku_name            = "standard"
    tags = {
      Purpose = "Development secrets"
    }
  }
}

# App Service Plans
app_service_plans = {
  "main" = {
    name                = "dev-asp"
    location            = "East US"
    resource_group_name = "dev-rg"
    os_type             = "Linux"
    sku_name            = "B1"
    tags = {
      Purpose = "Development app hosting"
    }
  }
}

# App Services
app_services = {
  "main" = {
    name                = "dev-app-001"
    location            = "East US"
    resource_group_name = "dev-rg"
    service_plan_id     = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/dev-rg/providers/Microsoft.Web/serverfarms/dev-asp"
    site_config = {
      always_on = false
    }
    tags = {
      Purpose = "Development web app"
    }
  }
}

# SQL Servers
sql_servers = {
  "main" = {
    name                         = "dev-sqlserver-001"
    resource_group_name          = "dev-rg"
    location                     = "East US"
    version                      = "12.0"
    administrator_login          = "sqladmin"
    administrator_login_password = "REPLACE_WITH_SECURE_PASSWORD" # Use Azure Key Vault or GitHub Secrets
    tags = {
      Purpose = "Development database server"
    }
  }
}

# SQL Databases
sql_databases = {
  "main" = {
    name      = "dev-db"
    server_id = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/dev-rg/providers/Microsoft.Sql/servers/dev-sqlserver-001"
    sku_name  = "Basic"
    tags = {
      Purpose = "Development database"
    }
  }
}

# Container Registries
container_registries = {
  "main" = {
    name                = "devacr001"
    resource_group_name = "dev-rg"
    location            = "East US"
    sku                 = "Basic"
    admin_enabled       = true
    tags = {
      Purpose = "Development container images"
    }
  }
}

# AKS Clusters
aks_clusters = {
  "main" = {
    name                = "dev-aks"
    location            = "East US"
    resource_group_name = "dev-rg"
    dns_prefix          = "dev-aks"
    kubernetes_version  = "1.27.0"
    default_node_pool = {
      name       = "default"
      node_count = 1
      vm_size    = "Standard_B2s"
    }
    tags = {
      Purpose = "Development Kubernetes cluster"
    }
  }
}
