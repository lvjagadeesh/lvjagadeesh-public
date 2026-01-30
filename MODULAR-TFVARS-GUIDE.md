# Modular tfvars Organization Guide

This guide explains the new modular tfvars organization structure implemented in this repository.

## Overview

The repository now uses:
1. **Per-environment backend.tf files** - Separate backend configuration for each environment
2. **Resource-specific tfvars files** - Individual tfvars files for each resource type

## Directory Structure

```
environments/
├── dev/
│   ├── backend.tf                    # Dev backend configuration
│   ├── resource-groups.tfvars        # Resource groups only
│   ├── virtual-networks.tfvars       # Virtual networks only
│   ├── storage-accounts.tfvars       # Storage accounts only
│   ├── key-vaults.tfvars             # Key vaults only
│   ├── app-service-plans.tfvars      # App service plans only
│   ├── app-services.tfvars           # App services only
│   ├── sql-servers.tfvars            # SQL servers only
│   ├── sql-databases.tfvars          # SQL databases only
│   ├── container-registries.tfvars   # Container registries only
│   └── aks-clusters.tfvars           # AKS clusters only
├── staging/
│   ├── backend.tf
│   └── [10 resource-specific tfvars files]
└── production/
    ├── backend.tf
    └── [10 resource-specific tfvars files]
```

## Benefits

### 1. Better Organization
- Each resource type has its own file
- Easy to find and edit specific resource configurations
- Clear separation of concerns

### 2. Improved Git Workflow
- Smaller, focused commits
- Easier code reviews
- Reduced merge conflicts when multiple team members work on different resources

### 3. Flexible Deployments
- Deploy all resources or specific subsets
- Test individual resource types independently
- Faster iteration on specific components

### 4. Environment Isolation
- Each environment has its own backend configuration
- Prevents accidental cross-environment changes
- Clear separation of dev, staging, and production state

### 5. Better Collaboration
- Team members can work on different resource files simultaneously
- Less chance of conflicts
- Easier to assign ownership of specific resources

## Usage

### Initialize Backend

Each environment has its own backend configuration. Initialize with:

```bash
# Development
terraform init -backend-config=environments/dev/backend.tf

# Staging
terraform init -backend-config=environments/staging/backend.tf

# Production
terraform init -backend-config=environments/production/backend.tf
```

### Deploy All Resources

To deploy all resources in an environment, specify all tfvars files:

```bash
# Development - All resources
terraform plan \
  -var-file="environments/dev/resource-groups.tfvars" \
  -var-file="environments/dev/virtual-networks.tfvars" \
  -var-file="environments/dev/storage-accounts.tfvars" \
  -var-file="environments/dev/key-vaults.tfvars" \
  -var-file="environments/dev/app-service-plans.tfvars" \
  -var-file="environments/dev/app-services.tfvars" \
  -var-file="environments/dev/sql-servers.tfvars" \
  -var-file="environments/dev/sql-databases.tfvars" \
  -var-file="environments/dev/container-registries.tfvars" \
  -var-file="environments/dev/aks-clusters.tfvars"

terraform apply \
  -var-file="environments/dev/resource-groups.tfvars" \
  -var-file="environments/dev/virtual-networks.tfvars" \
  -var-file="environments/dev/storage-accounts.tfvars" \
  -var-file="environments/dev/key-vaults.tfvars" \
  -var-file="environments/dev/app-service-plans.tfvars" \
  -var-file="environments/dev/app-services.tfvars" \
  -var-file="environments/dev/sql-servers.tfvars" \
  -var-file="environments/dev/sql-databases.tfvars" \
  -var-file="environments/dev/container-registries.tfvars" \
  -var-file="environments/dev/aks-clusters.tfvars"
```

### Deploy Specific Resources

Deploy only the resources you need:

#### Foundation Only (Resource Groups + Networking)
```bash
terraform plan \
  -var-file="environments/dev/resource-groups.tfvars" \
  -var-file="environments/dev/virtual-networks.tfvars"
```

#### Storage Layer
```bash
terraform plan \
  -var-file="environments/dev/resource-groups.tfvars" \
  -var-file="environments/dev/storage-accounts.tfvars"
```

#### Application Layer
```bash
terraform plan \
  -var-file="environments/dev/resource-groups.tfvars" \
  -var-file="environments/dev/app-service-plans.tfvars" \
  -var-file="environments/dev/app-services.tfvars"
```

#### Database Layer
```bash
terraform plan \
  -var-file="environments/dev/resource-groups.tfvars" \
  -var-file="environments/dev/sql-servers.tfvars" \
  -var-file="environments/dev/sql-databases.tfvars"
```

#### Container & Kubernetes Layer
```bash
terraform plan \
  -var-file="environments/dev/resource-groups.tfvars" \
  -var-file="environments/dev/container-registries.tfvars" \
  -var-file="environments/dev/aks-clusters.tfvars"
```

## Automation with Scripts

### Bash Script Example

Create a deploy script for each environment:

```bash
#!/bin/bash
# deploy-dev.sh

ENV="dev"
TFVARS_DIR="environments/${ENV}"

terraform init -backend-config="${TFVARS_DIR}/backend.tf"

terraform plan \
  -var-file="${TFVARS_DIR}/resource-groups.tfvars" \
  -var-file="${TFVARS_DIR}/virtual-networks.tfvars" \
  -var-file="${TFVARS_DIR}/storage-accounts.tfvars" \
  -var-file="${TFVARS_DIR}/key-vaults.tfvars" \
  -var-file="${TFVARS_DIR}/app-service-plans.tfvars" \
  -var-file="${TFVARS_DIR}/app-services.tfvars" \
  -var-file="${TFVARS_DIR}/sql-servers.tfvars" \
  -var-file="${TFVARS_DIR}/sql-databases.tfvars" \
  -var-file="${TFVARS_DIR}/container-registries.tfvars" \
  -var-file="${TFVARS_DIR}/aks-clusters.tfvars" \
  -out="${ENV}.tfplan"

# Review the plan before applying
read -p "Apply this plan? (yes/no): " apply
if [ "$apply" == "yes" ]; then
  terraform apply "${ENV}.tfplan"
fi
```

### Makefile Example

```makefile
.PHONY: plan-dev plan-staging plan-prod apply-dev apply-staging apply-prod

TFVARS_DEV = environments/dev
TFVARS_STAGING = environments/staging
TFVARS_PROD = environments/production

VAR_FILES = -var-file="$(1)/resource-groups.tfvars" \
            -var-file="$(1)/virtual-networks.tfvars" \
            -var-file="$(1)/storage-accounts.tfvars" \
            -var-file="$(1)/key-vaults.tfvars" \
            -var-file="$(1)/app-service-plans.tfvars" \
            -var-file="$(1)/app-services.tfvars" \
            -var-file="$(1)/sql-servers.tfvars" \
            -var-file="$(1)/sql-databases.tfvars" \
            -var-file="$(1)/container-registries.tfvars" \
            -var-file="$(1)/aks-clusters.tfvars"

plan-dev:
	terraform init -backend-config=$(TFVARS_DEV)/backend.tf
	terraform plan $(call VAR_FILES,$(TFVARS_DEV)) -out=dev.tfplan

apply-dev:
	terraform apply dev.tfplan

plan-staging:
	terraform init -backend-config=$(TFVARS_STAGING)/backend.tf
	terraform plan $(call VAR_FILES,$(TFVARS_STAGING)) -out=staging.tfplan

apply-staging:
	terraform apply staging.tfplan

plan-prod:
	terraform init -backend-config=$(TFVARS_PROD)/backend.tf
	terraform plan $(call VAR_FILES,$(TFVARS_PROD)) -out=prod.tfplan

apply-prod:
	terraform apply prod.tfplan
```

## Backend Configuration

Each environment has its own backend configuration to store Terraform state separately.

### Development Backend
- Storage Account: `tfstatedevstg`
- Container: `tfstate-dev`
- State File: `dev.terraform.tfstate`

### Staging Backend
- Storage Account: `tfstatestagingstg`
- Container: `tfstate-staging`
- State File: `staging.terraform.tfstate`

### Production Backend
- Storage Account: `tfstateprodstg`
- Container: `tfstate-prod`
- State File: `prod.terraform.tfstate`

### Setup Backend Storage

Before using the backend configurations, create the Azure Storage accounts and containers:

```bash
# Create resource group for state storage
az group create --name terraform-state-rg --location "East US"

# Development
az storage account create \
  --name tfstatedevstg \
  --resource-group terraform-state-rg \
  --location "East US" \
  --sku Standard_LRS
az storage container create \
  --name tfstate-dev \
  --account-name tfstatedevstg

# Staging
az storage account create \
  --name tfstatestagingstg \
  --resource-group terraform-state-rg \
  --location "East US" \
  --sku Standard_LRS
az storage container create \
  --name tfstate-staging \
  --account-name tfstatestagingstg

# Production (use GRS for production)
az storage account create \
  --name tfstateprodstg \
  --resource-group terraform-state-rg \
  --location "East US" \
  --sku Standard_GRS
az storage container create \
  --name tfstate-prod \
  --account-name tfstateprodstg
```

## File Naming Convention

All resource-specific tfvars files follow the pattern: `<resource-type-plural>.tfvars`

- `resource-groups.tfvars` - Contains `resource_groups` variable
- `virtual-networks.tfvars` - Contains `virtual_networks` variable
- `storage-accounts.tfvars` - Contains `storage_accounts` variable
- `key-vaults.tfvars` - Contains `key_vaults` variable
- `app-service-plans.tfvars` - Contains `app_service_plans` variable
- `app-services.tfvars` - Contains `app_services` variable
- `sql-servers.tfvars` - Contains `sql_servers` variable
- `sql-databases.tfvars` - Contains `sql_databases` variable
- `container-registries.tfvars` - Contains `container_registries` variable
- `aks-clusters.tfvars` - Contains `aks_clusters` variable

## Best Practices

### 1. Version Control
- Commit resource-specific tfvars files separately
- Use descriptive commit messages referencing the resource type
- Tag releases with environment-specific tags

### 2. Code Reviews
- Review changes to specific resource files independently
- Easier to spot configuration issues
- Reduced cognitive load

### 3. Documentation
- Add comments in each tfvars file explaining configurations
- Document dependencies between resources
- Keep README updated with current resource list

### 4. Security
- Never commit sensitive values to Git
- Use Azure Key Vault references or environment variables
- Update backend.tf with your actual subscription and tenant IDs

### 5. Testing
- Test resource-specific changes in dev first
- Use terraform plan to review changes before applying
- Consider using automated testing tools like Terratest

## Migration from Monolithic Files

If you're migrating from the old single-file structure:

1. **Backup existing tfvars files**
   ```bash
   cp environments/dev/terraform.tfvars environments/dev/terraform.tfvars.backup
   ```

2. **Split configurations** - Content is already split in new files

3. **Update CI/CD pipelines** - Adjust to use multiple -var-file flags

4. **Test thoroughly** - Verify all resources are still configured correctly

5. **Remove old files** - Once confident, remove the monolithic files
   ```bash
   rm environments/*/terraform.tfvars.backup
   ```

## Troubleshooting

### Issue: Variable not defined
**Problem**: Forgot to include a tfvars file
**Solution**: Ensure all required tfvars files are included in the terraform plan/apply command

### Issue: Resource dependencies failing
**Problem**: Resources created in wrong order
**Solution**: Include all dependent resource tfvars files (e.g., resource groups before other resources)

### Issue: Backend initialization fails
**Problem**: Backend storage account doesn't exist
**Solution**: Create the storage account and container first (see Backend Configuration section)

## Summary

This modular approach provides:
- ✅ Better organization and maintainability
- ✅ Reduced merge conflicts
- ✅ Flexible deployment options
- ✅ Clear environment isolation
- ✅ Easier collaboration
- ✅ Improved security through separation

The structure scales well as your infrastructure grows and makes it easier to manage complex multi-environment deployments.
