# Quick Start Guide - Azure Terraform Modules

## 🎯 What Changed?

This repository has been refactored to provide **independent, reusable Terraform modules** for Azure infrastructure.

### Key Changes:
1. ✅ **Latest Versions**: Terraform 1.14.0+ and AzureRM Provider 4.58+
2. ✅ **for_each Pattern**: Create multiple instances of any resource
3. ✅ **No Dependencies**: Modules work independently
4. ✅ **Clear Variables**: All marked as (Required) or (Optional)

## �� Quick Usage

### Option 1: Use a Single Module in Your Project

```hcl
# In your project's main.tf
module "my_storage" {
  source = "git::https://github.com/lvjagadeesh/lvjagadeesh-public.git//modules/storage-account?ref=main"
  
  storage_account_name     = "mystorageacct"
  resource_group_name      = "my-existing-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

### Option 2: Clone and Use All Modules

```bash
git clone https://github.com/lvjagadeesh/lvjagadeesh-public.git
cd lvjagadeesh-public

# Copy example configuration
cp environments/dev/terraform.tfvars.example my-config.tfvars

# Edit with your values
vim my-config.tfvars

# Initialize and apply
terraform init
terraform plan -var-file="my-config.tfvars"
terraform apply -var-file="my-config.tfvars"
```

## 📦 Available Modules

All modules are independent and can be used alone:

| Module | Purpose | Example Name |
|--------|---------|--------------|
| `resource-group` | Azure Resource Group | my-rg |
| `virtual-network` | VNet with subnets | my-vnet |
| `storage-account` | Blob storage | mystorageacct |
| `key-vault` | Secrets management | my-kv |
| `app-service-plan` | App hosting plan | my-asp |
| `app-service` | Web application | my-app |
| `sql-server` | SQL Server | my-sqlserver |
| `sql-database` | SQL Database | my-db |
| `container-registry` | Docker registry | myacr |
| `aks-cluster` | Kubernetes cluster | my-aks |

## 🔧 Configuration Pattern

### Old Way (Single Instance):
```hcl
resource_group_name = "my-rg"
```

### New Way (Multiple Instances with for_each):
```hcl
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
```

## 📝 Example Configuration

```hcl
# Create multiple resource groups
resource_groups = {
  "app" = {
    name     = "prod-app-rg"
    location = "East US"
  }
}

# Create storage accounts in existing resource groups
storage_accounts = {
  "app_storage" = {
    name                     = "prodappstorage"
    resource_group_name      = "prod-app-rg"  # Reference by name
    location                 = "East US"
    account_replication_type = "GRS"
  }
}
```

## ✅ Validation

All variables have validation:

```hcl
# ✅ Valid
storage_account_name = "mystorageacct"  # 3-24 chars, lowercase

# ❌ Invalid
storage_account_name = "MyStorageAccount"  # Uppercase not allowed
```

## 🎓 Learn More

- **Full Documentation**: See [README.md](README.md)
- **Detailed Changes**: See [REFACTORING-SUMMARY.md](REFACTORING-SUMMARY.md)
- **Example Usage**: See [environments/dev/terraform.tfvars.example](environments/dev/terraform.tfvars.example)

## 🔍 Module Variables

Each module clearly marks required vs optional:

```hcl
variable "storage_account_name" {
  description = "(Required) Name of the storage account..."
  type        = string
  # No default - must be provided
}

variable "account_tier" {
  description = "(Optional) Storage account tier. Default: Standard"
  type        = string
  default     = "Standard"  # Has default - optional
}
```

## 🆘 Need Help?

1. Check module's `example/terraform.tfvars` for usage
2. See `variables.tf` for all available options
3. Review validation errors for guidance
4. Read the comprehensive README.md

## 🎉 Benefits

- **Independent**: Use any module without others
- **Scalable**: Create multiple instances easily
- **Validated**: Comprehensive input validation
- **Modern**: Latest Terraform and Azure features
- **Reusable**: Share modules across projects
