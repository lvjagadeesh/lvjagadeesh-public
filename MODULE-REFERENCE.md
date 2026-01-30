# Azure Terraform Modules - Complete Reference

This document provides a comprehensive reference for all Azure Terraform modules developed in this repository.

## 📦 Module Inventory

This repository contains **10 production-ready Azure Terraform modules** for common infrastructure components:

| # | Module Name | Azure Resource | Purpose |
|---|-------------|----------------|---------|
| 1 | **resource-group** | Azure Resource Group | Logical container for Azure resources |
| 2 | **virtual-network** | Azure Virtual Network | Network isolation and segmentation with subnets |
| 3 | **storage-account** | Azure Storage Account | Blob, file, queue, and table storage |
| 4 | **key-vault** | Azure Key Vault | Secrets, keys, and certificate management |
| 5 | **app-service-plan** | Azure App Service Plan | Hosting plan for web applications |
| 6 | **app-service** | Azure App Service (Linux) | Web application hosting |
| 7 | **sql-server** | Azure SQL Server | Relational database server |
| 8 | **sql-database** | Azure SQL Database | Managed SQL database |
| 9 | **container-registry** | Azure Container Registry | Docker container image registry |
| 10 | **aks-cluster** | Azure Kubernetes Service | Managed Kubernetes cluster |

## 📖 Module Details

### 1. resource-group
**Module Path**: `modules/resource-group`  
**Terraform Resource**: `azurerm_resource_group`  
**Purpose**: Creates an Azure Resource Group to logically organize and manage Azure resources.

**Key Features**:
- ✅ Name validation (1-90 characters)
- ✅ Location configuration
- ✅ Managed-by tracking
- ✅ Resource tagging

**Usage**:
```hcl
module "resource_group" {
  source = "./modules/resource-group"
  
  resource_group_name = "my-rg"
  location            = "East US"
  tags = {
    Environment = "Production"
  }
}
```

**Example**: [`modules/resource-group/example/terraform.tfvars`](modules/resource-group/example/terraform.tfvars)

---

### 2. virtual-network
**Module Path**: `modules/virtual-network`  
**Terraform Resource**: `azurerm_virtual_network`, `azurerm_subnet`  
**Purpose**: Creates a Virtual Network with optional subnets for network isolation and segmentation.

**Key Features**:
- ✅ VNet name validation (1-64 characters)
- ✅ Multiple address spaces
- ✅ Custom DNS servers
- ✅ BGP community configuration
- ✅ DDoS protection plan integration
- ✅ VNet encryption
- ✅ Flow timeout configuration
- ✅ Edge zone support
- ✅ Subnet creation with delegation support
- ✅ Service endpoints
- ✅ Private endpoint network policies

**Usage**:
```hcl
module "virtual_network" {
  source = "./modules/virtual-network"
  
  vnet_name           = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "my-rg"
  
  subnets = [
    {
      name             = "subnet1"
      address_prefixes = ["10.0.1.0/24"]
    }
  ]
}
```

**Example**: [`modules/virtual-network/example/terraform.tfvars`](modules/virtual-network/example/terraform.tfvars)

---

### 3. storage-account
**Module Path**: `modules/storage-account`  
**Terraform Resource**: `azurerm_storage_account`  
**Purpose**: Creates a Storage Account for blob, file, queue, and table storage with advanced features.

**Key Features** (Comprehensive - 42 variables):
- ✅ Storage account name validation (3-24 chars, lowercase)
- ✅ Multiple account kinds (BlobStorage, BlockBlobStorage, FileStorage, StorageV2)
- ✅ Replication types (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)
- ✅ Access tiers (Hot, Cool, Cold, Archive)
- ✅ Data Lake Gen 2 support (Hierarchical Namespace)
- ✅ NFSv3 protocol support
- ✅ SFTP support
- ✅ Blob properties (versioning, change feed, retention, CORS)
- ✅ Queue properties (logging, metrics)
- ✅ Static website hosting
- ✅ File share properties with SMB configuration
- ✅ Azure Files authentication (AD/AADDS/AADKERB)
- ✅ Advanced networking with private link access
- ✅ Managed identity support
- ✅ Customer-managed encryption keys
- ✅ SAS token policies
- ✅ Immutability policies
- ✅ Infrastructure encryption
- ✅ Cross-tenant replication control
- ✅ Public network access control

**Usage**:
```hcl
module "storage_account" {
  source = "./modules/storage-account"
  
  storage_account_name     = "mystorageacct"
  resource_group_name      = "my-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  
  # Enable Data Lake Gen 2
  is_hns_enabled = true
  
  # Configure blob retention
  blob_properties = {
    delete_retention_policy = {
      days = 7
    }
  }
}
```

**Example**: [`modules/storage-account/example/terraform.tfvars`](modules/storage-account/example/terraform.tfvars)

---

### 4. key-vault
**Module Path**: `modules/key-vault`  
**Terraform Resource**: `azurerm_key_vault`  
**Purpose**: Creates a Key Vault for secure storage and management of secrets, keys, and certificates.

**Key Features**:
- ✅ Key vault name validation (3-24 characters)
- ✅ SKU selection (standard, premium)
- ✅ Soft delete with configurable retention (7-90 days)
- ✅ Purge protection
- ✅ Network ACLs with IP rules and virtual network rules
- ✅ Default action configuration (Allow/Deny)
- ✅ Resource tagging

**Usage**:
```hcl
module "key_vault" {
  source = "./modules/key-vault"
  
  key_vault_name      = "my-kv"
  location            = "East US"
  resource_group_name = "my-rg"
  sku_name            = "standard"
  
  network_acls = {
    default_action = "Deny"
    ip_rules       = ["1.2.3.4/32"]
  }
}
```

**Example**: [`modules/key-vault/example/terraform.tfvars`](modules/key-vault/example/terraform.tfvars)

---

### 5. app-service-plan
**Module Path**: `modules/app-service-plan`  
**Terraform Resource**: `azurerm_service_plan`  
**Purpose**: Creates an App Service Plan that defines the compute resources for web applications.

**Key Features**:
- ✅ Plan name validation (1-60 characters)
- ✅ OS type selection (Linux, Windows)
- ✅ SKU configuration (B1, S1, P1V2, etc.)
- ✅ Resource tagging

**Usage**:
```hcl
module "app_service_plan" {
  source = "./modules/app-service-plan"
  
  app_service_plan_name = "my-asp"
  location              = "East US"
  resource_group_name   = "my-rg"
  os_type               = "Linux"
  sku_name              = "B1"
}
```

**Example**: [`modules/app-service-plan/example/terraform.tfvars`](modules/app-service-plan/example/terraform.tfvars)

---

### 6. app-service
**Module Path**: `modules/app-service`  
**Terraform Resource**: `azurerm_linux_web_app`  
**Purpose**: Creates a Linux-based Web App for hosting web applications and APIs.

**Key Features**:
- ✅ App name validation (1-60 characters, alphanumeric and hyphens)
- ✅ Service plan association
- ✅ Site configuration
- ✅ Docker container support
- ✅ Application settings
- ✅ Connection strings
- ✅ Managed identity support
- ✅ Resource tagging

**Usage**:
```hcl
module "app_service" {
  source = "./modules/app-service"
  
  app_name            = "my-web-app"
  location            = "East US"
  resource_group_name = "my-rg"
  service_plan_id     = module.app_service_plan.service_plan_id
  
  site_config = {
    always_on = true
  }
}
```

**Example**: [`modules/app-service/example/terraform.tfvars`](modules/app-service/example/terraform.tfvars)

---

### 7. sql-server
**Module Path**: `modules/sql-server`  
**Terraform Resource**: `azurerm_mssql_server`  
**Purpose**: Creates an Azure SQL Server instance for hosting SQL databases.

**Key Features**:
- ✅ Server name validation (1-63 characters, lowercase)
- ✅ SQL Server version selection (2.0, 12.0)
- ✅ Administrator credentials
- ✅ Minimum TLS version configuration
- ✅ Azure AD administrator support
- ✅ Public network access control
- ✅ Resource tagging

**Usage**:
```hcl
module "sql_server" {
  source = "./modules/sql-server"
  
  sql_server_name          = "my-sqlserver"
  location                 = "East US"
  resource_group_name      = "my-rg"
  administrator_login      = "sqladmin"
  administrator_password   = "P@ssw0rd123!"
  sql_server_version       = "12.0"
  minimum_tls_version      = "1.2"
}
```

**Example**: [`modules/sql-server/example/terraform.tfvars`](modules/sql-server/example/terraform.tfvars)

---

### 8. sql-database
**Module Path**: `modules/sql-database`  
**Terraform Resource**: `azurerm_mssql_database`  
**Purpose**: Creates an Azure SQL Database within a SQL Server.

**Key Features**:
- ✅ Database name validation (1-128 characters)
- ✅ License type selection
- ✅ SKU configuration
- ✅ Maximum size configuration
- ✅ Zone redundancy support
- ✅ Resource tagging

**Usage**:
```hcl
module "sql_database" {
  source = "./modules/sql-database"
  
  database_name    = "my-database"
  sql_server_id    = module.sql_server.sql_server_id
  license_type     = "LicenseIncluded"
  max_size_gb      = 10
  sku_name         = "Basic"
}
```

**Example**: [`modules/sql-database/example/terraform.tfvars`](modules/sql-database/example/terraform.tfvars)

---

### 9. container-registry
**Module Path**: `modules/container-registry`  
**Terraform Resource**: `azurerm_container_registry`  
**Purpose**: Creates an Azure Container Registry for storing and managing Docker container images.

**Key Features**:
- ✅ Registry name validation (5-50 characters, alphanumeric only)
- ✅ SKU selection (Basic, Standard, Premium)
- ✅ Admin user configuration
- ✅ Geo-replication support (Premium SKU)
- ✅ Network rules configuration
- ✅ Public network access control
- ✅ Resource tagging

**Usage**:
```hcl
module "container_registry" {
  source = "./modules/container-registry"
  
  acr_name            = "myacr"
  location            = "East US"
  resource_group_name = "my-rg"
  sku                 = "Premium"
  admin_enabled       = false
  
  georeplications = [
    {
      location = "West US"
    }
  ]
}
```

**Example**: [`modules/container-registry/example/terraform.tfvars`](modules/container-registry/example/terraform.tfvars)

---

### 10. aks-cluster
**Module Path**: `modules/aks-cluster`  
**Terraform Resource**: `azurerm_kubernetes_cluster`  
**Purpose**: Creates an Azure Kubernetes Service (AKS) cluster for container orchestration.

**Key Features**:
- ✅ Cluster name validation (1-63 characters)
- ✅ DNS prefix validation (1-54 characters)
- ✅ Kubernetes version selection
- ✅ Default node pool configuration
- ✅ Auto-scaling support
- ✅ System-assigned managed identity
- ✅ Network plugin selection (azure, kubenet)
- ✅ Load balancer SKU selection
- ✅ Resource tagging

**Usage**:
```hcl
module "aks_cluster" {
  source = "./modules/aks-cluster"
  
  cluster_name          = "my-aks"
  location              = "East US"
  resource_group_name   = "my-rg"
  dns_prefix            = "myaks"
  kubernetes_version    = "1.27"
  
  default_node_pool_name    = "default"
  default_node_pool_vm_size = "Standard_D2s_v3"
  default_node_pool_count   = 3
  
  enable_auto_scaling = true
  min_node_count      = 2
  max_node_count      = 5
}
```

**Example**: [`modules/aks-cluster/example/terraform.tfvars`](modules/aks-cluster/example/terraform.tfvars)

---

## 📁 Module Structure

Each module follows a consistent structure:

```
modules/<module-name>/
├── main.tf          # Resource definitions
├── variables.tf     # Input variables with validation
├── outputs.tf       # Output values
├── provider.tf      # Provider version constraints
└── example/
    └── terraform.tfvars  # Example usage
```

## 🔄 Module Usage Patterns

### Pattern 1: Using Individual Modules

Use any module independently in your project:

```hcl
module "my_storage" {
  source = "git::https://github.com/lvjagadeesh/lvjagadeesh-public.git//modules/storage-account?ref=main"
  
  storage_account_name = "mystorageacct"
  resource_group_name  = "existing-rg"
  location             = "East US"
}
```

### Pattern 2: Using Multiple Modules Together

Combine modules for complete infrastructure:

```hcl
module "rg" {
  source = "./modules/resource-group"
  resource_group_name = "my-rg"
  location            = "East US"
}

module "vnet" {
  source = "./modules/virtual-network"
  vnet_name           = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = module.rg.location
  resource_group_name = module.rg.resource_group_name
}

module "aks" {
  source = "./modules/aks-cluster"
  cluster_name        = "my-aks"
  location            = module.rg.location
  resource_group_name = module.rg.resource_group_name
  dns_prefix          = "myaks"
}
```

### Pattern 3: Using for_each for Multiple Instances

Create multiple instances of the same resource type:

```hcl
module "storage_accounts" {
  source   = "./modules/storage-account"
  for_each = var.storage_accounts
  
  storage_account_name     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_replication_type = each.value.replication_type
}
```

## 🎯 Module Features

### All Modules Include:

- ✅ **Terraform 1.14.0+** compatibility
- ✅ **AzureRM Provider 4.58+** support
- ✅ **Comprehensive validation** on all inputs
- ✅ **Clear documentation** with (Required) and (Optional) markers
- ✅ **Sensible defaults** for optional parameters
- ✅ **Production-ready** configurations
- ✅ **Resource tagging** support
- ✅ **Example configurations** in each module

### Enhanced Modules:

Three modules have been significantly enhanced with ALL available AzureRM 4.58 attributes:

1. **resource-group** - Basic enhancement (managed_by)
2. **virtual-network** - Advanced networking features (DDoS, encryption, delegation)
3. **storage-account** - Comprehensive features (42 variables, 11 configuration blocks)

## 📚 Additional Documentation

- **[README.md](README.md)** - Main repository documentation with comprehensive usage guide
- **[QUICK-START.md](QUICK-START.md)** - Quick start guide for new users
- **[REFACTORING-SUMMARY.md](REFACTORING-SUMMARY.md)** - Details about the refactoring to for_each pattern
- **[IMPLEMENTATION-STATUS.md](IMPLEMENTATION-STATUS.md)** - Detailed guide for enhancing remaining modules
- **[COMPREHENSIVE-MODULES-GUIDE.md](COMPREHENSIVE-MODULES-GUIDE.md)** - Module enhancement tracking

## 🚀 Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/lvjagadeesh/lvjagadeesh-public.git
   cd lvjagadeesh-public
   ```

2. **Choose a module** from the list above

3. **Review the example**:
   ```bash
   cat modules/<module-name>/example/terraform.tfvars
   ```

4. **Use in your configuration**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## 📞 Support

For issues or questions about specific modules, please refer to:
- Module example files in `modules/<module-name>/example/`
- Main README.md documentation
- Variable descriptions in `modules/<module-name>/variables.tf`

## 🏗️ Module Independence

All modules are designed to be **completely independent**:
- ✅ No cross-module dependencies
- ✅ Can be used in isolation
- ✅ Can be mixed with other Terraform code
- ✅ Can be sourced from Git
- ✅ Fully reusable across projects

## 📊 Module Maturity

| Module | Variables | Enhancement Level | Status |
|--------|-----------|------------------|---------|
| resource-group | 4 | Basic | ✅ Complete |
| virtual-network | 11 | Advanced | ✅ Complete |
| storage-account | 42 | Comprehensive | ✅ Complete |
| key-vault | 11 | Standard | ✅ Functional |
| app-service-plan | 5 | Basic | ✅ Functional |
| app-service | 8 | Standard | ✅ Functional |
| sql-server | 9 | Standard | ✅ Functional |
| sql-database | 7 | Basic | ✅ Functional |
| container-registry | 6 | Basic | ✅ Functional |
| aks-cluster | 14 | Standard | ✅ Functional |

**Legend**:
- **Basic**: Core features implemented
- **Standard**: Common features implemented
- **Advanced**: Extended features implemented
- **Comprehensive**: ALL AzureRM provider features implemented

---

## 📝 Module Naming Convention

Module directory names follow Azure resource naming:
- Lowercase with hyphens
- Descriptive of the Azure resource
- Matches common Terraform naming patterns

Example mappings:
- `resource-group` → `azurerm_resource_group`
- `storage-account` → `azurerm_storage_account`
- `aks-cluster` → `azurerm_kubernetes_cluster`

---

**Last Updated**: 2026-01-29  
**Terraform Version**: >= 1.14.0  
**AzureRM Provider**: ~> 4.58
