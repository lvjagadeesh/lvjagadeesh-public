# Azure Terraform Infrastructure - Modular & Independent Design

Production-ready Azure Terraform infrastructure with fully independent modules, for_each pattern support, and latest provider versions.

## ❓ What this repository is used for

This repository is used to **define and deploy Azure infrastructure using Terraform**. It provides reusable modules for core Azure services (networking, storage, Key Vault, App Service, SQL, ACR, AKS), plus root-level configuration and environment-specific `tfvars` to deploy consistent infrastructure across development, staging, and production.

## 📦 Quick Module Reference

**10 Production-Ready Modules Available**:

| Module | Purpose | Documentation |
|--------|---------|---------------|
| `resource-group` | Resource Group | [Details](MODULE-REFERENCE.md#1-resource-group) |
| `virtual-network` | Virtual Network + Subnets | [Details](MODULE-REFERENCE.md#2-virtual-network) |
| `storage-account` | Storage Account (Enhanced) | [Details](MODULE-REFERENCE.md#3-storage-account) |
| `key-vault` | Key Vault | [Details](MODULE-REFERENCE.md#4-key-vault) |
| `app-service-plan` | App Service Plan | [Details](MODULE-REFERENCE.md#5-app-service-plan) |
| `app-service` | Linux Web App | [Details](MODULE-REFERENCE.md#6-app-service) |
| `sql-server` | SQL Server | [Details](MODULE-REFERENCE.md#7-sql-server) |
| `sql-database` | SQL Database | [Details](MODULE-REFERENCE.md#8-sql-database) |
| `container-registry` | Container Registry | [Details](MODULE-REFERENCE.md#9-container-registry) |
| `aks-cluster` | Kubernetes Cluster | [Details](MODULE-REFERENCE.md#10-aks-cluster) |

📖 **See [MODULE-REFERENCE.md](MODULE-REFERENCE.md) for complete details** on each module including features, usage examples, and configurations.  
📝 **See [MODULES.md](MODULES.md) for a quick reference list**.

## 📋 Overview

This repository contains **10 independent Azure Terraform modules** that can be used individually or together. Each module is designed as a standalone layer with no dependencies on other modules, making them perfect for reuse across different projects.

### Key Features

- ✅ **Latest Versions**: Terraform 1.14.0+ and AzureRM Provider 4.58+
- ✅ **Independent Modules**: No cross-module dependencies
- ✅ **for_each Pattern**: Create multiple instances of any resource
- ✅ **Required/Optional Variables**: Clearly marked with validation
- ✅ **Modular Design**: Pick any module without needing others
- ✅ **Production Ready**: Security best practices and comprehensive validation

## 🏗️ Module Architecture

### Available Modules

Each module can be used independently:

1. **resource-group** - Azure Resource Group management
2. **virtual-network** - VNet with subnet configuration
3. **storage-account** - Blob storage with advanced features
4. **key-vault** - Secrets and key management
5. **app-service-plan** - App Service hosting plan
6. **app-service** - Web application hosting
7. **sql-server** - Managed SQL Server
8. **sql-database** - SQL Database
9. **container-registry** - Azure Container Registry (ACR)
10. **aks-cluster** - Azure Kubernetes Service (AKS)

### Module Structure

Each module follows a consistent structure:

```
modules/<module-name>/
├── main.tf          # Resource definitions
├── variables.tf     # Input variables (Required/Optional marked)
├── outputs.tf       # Output values
├── provider.tf      # Terraform & Provider version constraints
└── example/
    └── terraform.tfvars  # Example usage
```

## 🚀 Usage

### Using Individual Modules

You can use any module independently in your project:

```hcl
# Example: Using just the resource-group module
module "my_resource_group" {
  source = "git::https://github.com/lvjagadeesh/lvjagadeesh-public.git//modules/resource-group?ref=main"

  resource_group_name = "my-rg"
  location            = "East US"
  tags = {
    Environment = "Production"
  }
}
```

### Using Multiple Instances with for_each

The root configuration uses `for_each` to enable creating multiple instances:

```hcl
# Create multiple resource groups
resource_groups = {
  "primary" = {
    name     = "prod-rg-primary"
    location = "East US"
  }
  "secondary" = {
    name     = "prod-rg-secondary"
    location = "West US"
  }
}

# Create multiple virtual networks
virtual_networks = {
  "vnet1" = {
    name                = "prod-vnet-1"
    address_space       = ["10.0.0.0/16"]
    location            = "East US"
    resource_group_name = "prod-rg-primary"  # Direct reference
    subnets = [
      {
        name             = "subnet1"
        address_prefixes = ["10.0.1.0/24"]
      }
    ]
  }
  "vnet2" = {
    name                = "prod-vnet-2"
    address_space       = ["10.1.0.0/16"]
    location            = "West US"
    resource_group_name = "prod-rg-secondary"
  }
}
```

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/lvjagadeesh/lvjagadeesh-public.git
   cd lvjagadeesh-public
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Create your tfvars file**
   ```bash
   cp environments/dev/terraform.tfvars.example my-config.tfvars
   # Edit my-config.tfvars with your values
   ```

4. **Plan and Apply**
   ```bash
   terraform plan -var-file="my-config.tfvars"
   terraform apply -var-file="my-config.tfvars"
   ```

## 📝 Module Independence

### No Cross-Module Dependencies

All modules are independent and don't reference each other's outputs. Instead, they accept resource identifiers as inputs:

```hcl
# ❌ OLD: Modules depended on each other
module "vnet" {
  resource_group_name = module.resource_group.name  # Dependency
}

# ✅ NEW: Modules are independent
module "vnet" {
  resource_group_name = "my-rg"  # Direct input
}
```

### Using Modules in Other Projects

Since modules are independent, you can easily use them in any project:

```hcl
# In your project's main.tf
module "my_storage" {
  source = "git::https://github.com/lvjagadeesh/lvjagadeesh-public.git//modules/storage-account?ref=main"

  storage_account_name     = "mystorageacct"
  resource_group_name      = "existing-rg"  # Reference existing RG
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
```

## 🔧 Variables

### Required vs Optional

All variables are clearly marked:

```hcl
variable "resource_group_name" {
  description = "(Required) Name of the resource group"
  type        = string
  
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "tags" {
  description = "(Optional) Tags to apply"
  type        = map(string)
  default     = {}
  nullable    = false
}
```

### Variable Validation

All modules include comprehensive validation:

- Name length and format checks
- Valid value constraints (SKUs, versions, etc.)
- Required field enforcement
- Logical consistency checks

## 📦 for_each Pattern

### Root Configuration

The root `main.tf` uses `for_each` for all modules:

```hcl
module "resource_group" {
  source   = "./modules/resource-group"
  for_each = var.resource_groups

  resource_group_name = each.value.name
  location            = each.value.location
  tags                = merge(var.common_tags, lookup(each.value, "tags", {}))
}
```

### Benefits

- Create multiple instances of any resource
- Clean, maintainable configuration
- Easy to add/remove resources
- No need to copy-paste module blocks

## 🌍 Environment Configuration

Example environment structure:

```hcl
# environments/production/terraform.tfvars
common_tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
}

resource_groups = {
  "app" = {
    name     = "prod-app-rg"
    location = "East US"
  }
  "data" = {
    name     = "prod-data-rg"
    location = "East US"
  }
}

storage_accounts = {
  "app_storage" = {
    name                     = "prodappstorage"
    resource_group_name      = "prod-app-rg"
    location                 = "East US"
    account_replication_type = "GRS"
  }
}
```

## 🔒 Security

- TLS 1.2+ minimum enforced
- Network rules default to Deny
- Managed identities for authentication
- Key Vault integration ready
- No hardcoded secrets
- Comprehensive input validation

### Secret Management

```bash
# Use environment variables
export TF_VAR_sql_servers='{"sql1": {"administrator_login_password": "SecureP@ssw0rd!"}}'

# Or use terraform.tfvars (never commit!)
echo 'sql_servers = { ... password = "SecureP@ssw0rd!" }' > secrets.auto.tfvars
```

## 📊 Outputs

Outputs use the same for_each pattern:

```hcl
# Access outputs
output "resource_groups" {
  value = {
    for k, rg in module.resource_group : k => {
      name = rg.resource_group_name
      id   = rg.resource_group_id
    }
  }
}
```

## 🔄 CI/CD Integration

The GitHub Actions workflow supports the new pattern:

- Validates all modules independently
- Supports multi-instance deployments
- Environment-specific configurations
- Automated security scanning

## 📖 Examples

See `environments/dev/terraform.tfvars.example` for a complete example with:
- Multiple resource groups
- Independent module configuration
- Optional and required parameters
- Best practices

## 🤝 Contributing

When adding new modules:
1. Follow the existing structure
2. Mark all variables as (Required) or (Optional)
3. Add comprehensive validation
4. Ensure module independence
5. Update this README

## 📄 Version History

- **v2.0**: Major refactor with for_each pattern and module independence
- **v1.0**: Initial release with basic modules

## 🔗 Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform for_each Meta-Argument](https://www.terraform.io/language/meta-arguments/for_each)
