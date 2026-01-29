# Environment tfvars Files Guide

## Overview

Each environment (dev, staging, production) has its own `terraform.tfvars` file that defines the infrastructure configuration for that environment using the new **for_each map-based structure**.

## Directory Structure

```
environments/
├── dev/
│   └── terraform.tfvars          # Development environment config
├── staging/
│   └── terraform.tfvars          # Staging environment config
└── production/
    └── terraform.tfvars          # Production environment config
```

## Usage

To deploy a specific environment:

```bash
# Development
terraform plan -var-file="environments/dev/terraform.tfvars"
terraform apply -var-file="environments/dev/terraform.tfvars"

# Staging
terraform plan -var-file="environments/staging/terraform.tfvars"
terraform apply -var-file="environments/staging/terraform.tfvars"

# Production
terraform plan -var-file="environments/production/terraform.tfvars"
terraform apply -var-file="environments/production/terraform.tfvars"
```

## File Structure

Each tfvars file follows the **map-based for_each pattern**:

```hcl
# Common tags applied to all resources
common_tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}

# Each module variable is a map where:
# - Key: Unique identifier for the resource
# - Value: Configuration object with all resource attributes

resource_groups = {
  "primary" = {
    name     = "dev-rg"
    location = "East US"
    tags     = { Purpose = "Primary resources" }
  }
}

storage_accounts = {
  "main" = {
    name                     = "devstorageacct001"
    resource_group_name      = "dev-rg"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}
```

## Benefits of Map-Based Structure

1. **Clean and Readable**: Each resource is clearly defined with all its properties
2. **Flexible**: Easy to add/remove resources by adding/removing map entries
3. **Consistent**: Same pattern across all 10 modules
4. **Type-Safe**: Full validation and type checking
5. **Self-Documenting**: Structure shows exactly what's configurable

## Environment Differences

### Development (dev/)
- **Purpose**: Testing and development
- **Characteristics**:
  - Lower SKUs (B1, Basic, Standard_B2s)
  - Single-node deployments
  - LRS storage replication
  - Minimal redundancy

### Staging (staging/)
- **Purpose**: Pre-production testing
- **Characteristics**:
  - Mid-tier SKUs (S1, Standard, Standard_D2_v2)
  - 2-node deployments
  - GRS storage replication
  - Moderate redundancy

### Production (production/)
- **Purpose**: Live production workloads
- **Characteristics**:
  - High-tier SKUs (P1v2, Premium, Standard_D4_v2)
  - 3+ node deployments with auto-scaling
  - GRS storage with zone redundancy
  - Maximum redundancy and security
  - Enhanced monitoring and backup

## Available Modules

Each environment tfvars file can configure all 10 modules:

1. **resource_groups** - Azure Resource Groups
2. **virtual_networks** - Virtual Networks with subnets
3. **storage_accounts** - Storage Accounts with advanced features
4. **key_vaults** - Key Vaults for secrets management
5. **app_service_plans** - App Service Plans (hosting plans)
6. **app_services** - Web Apps / App Services
7. **sql_servers** - SQL Server instances
8. **sql_databases** - SQL Databases
9. **container_registries** - Azure Container Registries
10. **aks_clusters** - Azure Kubernetes Service clusters

## Validation

All tfvars files have been:
- ✅ Syntax validated
- ✅ Formatted with `terraform fmt`
- ✅ Tested for structure compatibility
- ✅ Aligned with variables.tf requirements

## Security Notes

⚠️ **Important**: The tfvars files contain placeholder values:
- SQL passwords: `REPLACE_WITH_SECURE_PASSWORD`
- Subscription IDs: `SUBSCRIPTION_ID`
- Service Plan IDs: Use actual Azure resource IDs

**Best Practices**:
1. Store secrets in Azure Key Vault
2. Use Terraform variables or environment variables for sensitive data
3. Never commit actual passwords to version control
4. Use GitHub Secrets for CI/CD pipelines

## Customization

To customize for your needs:

1. **Add more resources**: Add more entries to any map
   ```hcl
   resource_groups = {
     "primary" = { ... }
     "secondary" = { ... }  # Add another resource group
   }
   ```

2. **Remove resources**: Delete map entries you don't need

3. **Modify configurations**: Change any attribute values to match your requirements

4. **Copy environments**: Create new environment folders by copying existing ones

## Testing

To test a tfvars file without applying:

```bash
# Validate syntax
terraform fmt -check environments/dev/terraform.tfvars

# Plan (dry-run)
terraform plan -var-file="environments/dev/terraform.tfvars"
```

## Related Documentation

- [README.md](../README.md) - Main project documentation
- [QUICK-START.md](../QUICK-START.md) - Quick start guide
- [MODULE-REFERENCE.md](../MODULE-REFERENCE.md) - Complete module reference
- [COMPLETE-MODULE-REFERENCE.md](../COMPLETE-MODULE-REFERENCE.md) - Detailed module documentation

## Support

Each module has its own README with detailed examples:
- `modules/<module-name>/README.md`
- `modules/<module-name>/example/terraform.tfvars`

