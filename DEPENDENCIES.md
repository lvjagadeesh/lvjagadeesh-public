# Resource Dependencies Guide

## Overview

This guide explains how dependencies are handled in this Terraform configuration and when you might need to customize the `depends_on` meta-argument.

## What is depends_on?

`depends_on` is a Terraform meta-argument that explicitly specifies dependencies between resources or modules. While Terraform automatically detects most dependencies through resource references, `depends_on` is needed when:

1. **Implicit dependencies**: A resource depends on another but doesn't directly reference it
2. **Creation order**: You need to enforce a specific creation sequence
3. **External dependencies**: Dependencies outside of direct resource references

## Current Dependency Chain

The root `main.tf` already includes `depends_on` declarations to ensure proper resource creation order:

```
┌─────────────────────┐
│  Resource Groups    │ (Foundation - created first)
└─────────┬───────────┘
          │
          ├──────────────────────────────────────────────┐
          │                                              │
          ▼                                              ▼
┌─────────────────────┐                    ┌─────────────────────┐
│  Virtual Networks   │                    │  Storage Accounts   │
│  Key Vaults         │                    │  SQL Servers        │
│  Container Registry │                    │  App Service Plans  │
└─────────┬───────────┘                    └─────────┬───────────┘
          │                                          │
          │                                          ▼
          │                                ┌─────────────────────┐
          │                                │   App Services      │
          │                                └─────────────────────┘
          │
          ▼
┌─────────────────────┐                    ┌─────────────────────┐
│   AKS Clusters      │◄───────────────────│   SQL Databases     │
└─────────────────────┘                    └─────────────────────┘
```

## Configured Dependencies

### Tier 1: Foundation (No dependencies)
```hcl
module "resource_group" {
  # No depends_on - created first
}
```

### Tier 2: Infrastructure (Depends on Resource Groups)
```hcl
module "virtual_network" {
  depends_on = [module.resource_group]
}

module "storage_account" {
  depends_on = [module.resource_group]
}

module "key_vault" {
  depends_on = [module.resource_group]
}

module "app_service_plan" {
  depends_on = [module.resource_group]
}

module "sql_server" {
  depends_on = [module.resource_group]
}

module "container_registry" {
  depends_on = [module.resource_group]
}
```

### Tier 3: Applications (Depends on Infrastructure)
```hcl
module "app_service" {
  depends_on = [
    module.resource_group,
    module.app_service_plan  # App Service needs the plan first
  ]
}

module "sql_database" {
  depends_on = [module.sql_server]  # Database needs server first
}

module "aks_cluster" {
  depends_on = [
    module.resource_group,
    module.virtual_network  # AKS often uses VNet subnets
  ]
}
```

## When to Add More Dependencies

### Scenario 1: App Service Needs Storage
If your App Service needs to reference a Storage Account:

```hcl
module "app_service" {
  source = "./modules/app-service"
  app_services = var.app_services

  depends_on = [
    module.resource_group,
    module.app_service_plan,
    module.storage_account  # Add storage dependency
  ]
}
```

### Scenario 2: AKS Needs Container Registry
If your AKS cluster pulls images from ACR:

```hcl
module "aks_cluster" {
  source = "./modules/aks-cluster"
  aks_clusters = var.aks_clusters

  depends_on = [
    module.resource_group,
    module.virtual_network,
    module.container_registry  # Add ACR dependency
  ]
}
```

### Scenario 3: App Service Needs Key Vault
If your App Service references secrets from Key Vault:

```hcl
module "app_service" {
  source = "./modules/app-service"
  app_services = var.app_services

  depends_on = [
    module.resource_group,
    module.app_service_plan,
    module.key_vault  # Add Key Vault dependency
  ]
}
```

### Scenario 4: SQL Database Needs Virtual Network
If your SQL Database uses VNet service endpoints:

```hcl
module "sql_database" {
  source = "./modules/sql-database"
  sql_databases = var.sql_databases

  depends_on = [
    module.sql_server,
    module.virtual_network  # Add VNet dependency for service endpoints
  ]
}
```

## Resource-Specific Dependencies

### Within tfvars Files

Some dependencies are handled through resource IDs in your tfvars:

```hcl
# In app-services.tfvars
app_services = {
  "web-app" = {
    name                = "myapp"
    resource_group_name = "my-rg"
    location            = "East US"
    service_plan_id     = "/subscriptions/.../Microsoft.Web/serverfarms/my-plan"
    # ↑ This creates an implicit dependency
  }
}
```

When you reference a resource ID, Terraform automatically understands the dependency. However, `depends_on` at the module level ensures the entire module is created in the correct order.

## Best Practices

### 1. Use Implicit Dependencies When Possible
✅ **Preferred** - Use resource references:
```hcl
app_services = {
  "web" = {
    service_plan_id = module.app_service_plan.app_service_plans["main"].id
  }
}
```

⚠️ **Less Preferred** - Add depends_on only when implicit doesn't work

### 2. Keep Dependencies Minimal
Only add `depends_on` when truly necessary. Unnecessary dependencies slow down parallel resource creation.

✅ **Good** - Only necessary dependencies:
```hcl
module "app_service" {
  depends_on = [module.app_service_plan]
}
```

❌ **Bad** - Overly restrictive:
```hcl
module "app_service" {
  depends_on = [
    module.resource_group,
    module.virtual_network,
    module.storage_account,
    module.key_vault,
    module.app_service_plan  # Only this is truly needed
  ]
}
```

### 3. Document Why Dependencies Exist
Add comments explaining why a dependency is needed:

```hcl
module "aks_cluster" {
  source = "./modules/aks-cluster"
  aks_clusters = var.aks_clusters

  # AKS needs VNet for subnet integration and RG for placement
  depends_on = [
    module.resource_group,
    module.virtual_network
  ]
}
```

### 4. Test Dependency Chains
After adding dependencies, test the creation order:

```bash
# See the creation order
terraform plan

# Verify dependencies work
terraform apply
```

## Common Dependency Patterns

### Pattern 1: Foundation → Infrastructure → Applications
```
Resource Groups → Storage/Network/KeyVault → Apps/Databases/Clusters
```

### Pattern 2: Parent → Child
```
SQL Server → SQL Databases
App Service Plan → App Services
Virtual Network → Subnets (handled within module)
```

### Pattern 3: Service → Configuration
```
AKS Cluster → Node Pools (handled within module)
Container Registry → Geo-Replications (handled within module)
```

## Troubleshooting

### Error: "Resource not found"
**Symptom**: Resources fail to create because they reference resources that don't exist yet.

**Solution**: Add `depends_on` to ensure the referenced resource is created first.

### Error: "Cycle in dependencies"
**Symptom**: Terraform detects a circular dependency.

**Solution**: Review your dependencies - two resources can't depend on each other. Restructure to break the cycle.

### Slow Apply
**Symptom**: `terraform apply` takes a long time with serial resource creation.

**Solution**: Remove unnecessary `depends_on` declarations to allow parallel creation.

## Advanced: Data Sources

If using data sources to reference existing resources, you typically don't need `depends_on`:

```hcl
data "azurerm_resource_group" "existing" {
  name = "existing-rg"
}

# Data sources are read before resource creation starts
```

## Customizing for Your Environment

To customize dependencies:

1. **Edit main.tf**: Add or modify `depends_on` in module blocks
2. **Test thoroughly**: Run `terraform plan` to verify dependency order
3. **Document changes**: Add comments explaining custom dependencies
4. **Consider alternatives**: Sometimes restructuring tfvars is better than adding dependencies

## Summary

### ✅ Current Setup
- All modules have appropriate `depends_on` declarations
- Resources are created in the correct order
- Typical Azure resource patterns are handled

### 🎯 When to Modify
- Adding new cross-module references
- Custom integration patterns
- Specific ordering requirements for your use case

### 📖 Key Points
1. `depends_on` ensures correct creation order
2. Already configured for common Azure patterns
3. Customize by editing `main.tf` module blocks
4. Test changes with `terraform plan`
5. Document why dependencies exist

## Examples in This Repository

See the configured dependencies in:
- **main.tf**: Module-level dependencies
- **QUICK-START.md**: Usage examples
- **README.md**: Overall architecture

For questions or issues with dependencies, refer to the [Terraform depends_on documentation](https://www.terraform.io/language/meta-arguments/depends_on).
