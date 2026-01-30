# Local Testing Guide

This guide shows you how to test your Terraform configurations locally before deploying.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Azure Authentication](#azure-authentication)
- [Testing Workflow](#testing-workflow)
- [Testing Specific Environments](#testing-specific-environments)
- [Validating Modules](#validating-modules)
- [Common Commands](#common-commands)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Software

1. **Terraform** (>= 1.14.0)
   ```bash
   # Check version
   terraform version
   
   # Install on Linux/Mac
   wget https://releases.hashicorp.com/terraform/1.14.4/terraform_1.14.4_linux_amd64.zip
   unzip terraform_1.14.4_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   
   # Or use package manager
   brew install terraform  # macOS
   choco install terraform # Windows
   ```

2. **Azure CLI** (>= 2.50.0)
   ```bash
   # Check version
   az version
   
   # Install
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash  # Linux
   brew install azure-cli                                   # macOS
   ```

3. **Git** (for cloning repository)
   ```bash
   git --version
   ```

## Azure Authentication

### Method 1: Azure CLI (Recommended for Local Testing)

```bash
# Login to Azure
az login

# Set subscription (if you have multiple)
az account list --output table
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Verify authentication
az account show
```

### Method 2: Service Principal (For CI/CD)

```bash
# Create service principal
az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"

# Set environment variables
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<subscription_id>"
export ARM_TENANT_ID="<tenant_id>"
```

### Method 3: Managed Identity (For Azure VMs)

```bash
# Already configured if running on Azure VM with managed identity
# No additional setup needed
```

## Testing Workflow

### Step 1: Clone Repository

```bash
git clone https://github.com/lvjagadeesh/lvjagadeesh-public.git
cd lvjagadeesh-public
```

### Step 2: Initialize Terraform

```bash
# Initialize with local backend (for testing)
terraform init

# Or initialize with Azure backend
terraform init \
  -backend-config="resource_group_name=tfstate-rg" \
  -backend-config="storage_account_name=tfstatedevstg" \
  -backend-config="container_name=tfstate-dev" \
  -backend-config="key=dev.terraform.tfstate"
```

### Step 3: Validate Configuration

```bash
# Check syntax and configuration
terraform validate

# Format all files
terraform fmt -recursive

# Check what will be created
terraform plan
```

### Step 4: Test with Specific Environment

```bash
# Test with dev environment (all resources)
terraform plan \
  $(for f in environments/dev/*.tfvars; do echo "-var-file=$f"; done)

# Test with staging environment
terraform plan \
  $(for f in environments/staging/*.tfvars; do echo "-var-file=$f"; done)

# Test with production environment
terraform plan \
  $(for f in environments/production/*.tfvars; do echo "-var-file=$f"; done)
```

### Step 5: Test Specific Resources

```bash
# Test only resource groups
terraform plan -var-file="environments/dev/resource-groups.tfvars"

# Test only networking
terraform plan \
  -var-file="environments/dev/resource-groups.tfvars" \
  -var-file="environments/dev/virtual-networks.tfvars"

# Test only storage
terraform plan \
  -var-file="environments/dev/resource-groups.tfvars" \
  -var-file="environments/dev/storage-accounts.tfvars"

# Test only compute (app services)
terraform plan \
  -var-file="environments/dev/resource-groups.tfvars" \
  -var-file="environments/dev/app-service-plans.tfvars" \
  -var-file="environments/dev/app-services.tfvars"
```

## Testing Specific Environments

### Development Environment

```bash
# Full plan for dev
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

# Save plan to file for review
terraform plan \
  $(for f in environments/dev/*.tfvars; do echo "-var-file=$f"; done) \
  -out=dev.tfplan

# Review saved plan
terraform show dev.tfplan
```

### Staging Environment

```bash
# Full plan for staging
terraform plan \
  $(for f in environments/staging/*.tfvars; do echo "-var-file=$f"; done) \
  -out=staging.tfplan

# Review
terraform show staging.tfplan
```

### Production Environment

```bash
# Full plan for production
terraform plan \
  $(for f in environments/production/*.tfvars; do echo "-var-file=$f"; done) \
  -out=production.tfplan

# Review (DO NOT APPLY without approval)
terraform show production.tfplan
```

## Validating Modules

### Test Individual Modules

```bash
# Test resource-group module
cd modules/resource-group
terraform init
terraform validate
terraform plan -var-file="example/terraform.tfvars"

# Test virtual-network module
cd modules/virtual-network
terraform init
terraform validate
terraform plan -var-file="example/terraform.tfvars"

# Return to root
cd ../..
```

### Test All Modules

```bash
# Create a script to test all modules
for module in modules/*/; do
  echo "Testing $module"
  cd "$module"
  terraform init -upgrade
  terraform validate
  terraform fmt -check
  cd ../..
done
```

## Common Commands

### Validation

```bash
# Validate syntax
terraform validate

# Check formatting
terraform fmt -check

# Format all files
terraform fmt -recursive

# Show current state
terraform show

# List all resources in state
terraform state list
```

### Planning

```bash
# Basic plan
terraform plan

# Plan with specific tfvars
terraform plan -var-file="environments/dev/resource-groups.tfvars"

# Plan with output to file
terraform plan -out=tfplan

# Plan and show changes in detail
terraform plan -detailed-exitcode

# Refresh state before plan
terraform plan -refresh=true
```

### Targeting Specific Resources

```bash
# Plan only specific module
terraform plan -target=module.resource_group

# Plan multiple targets
terraform plan \
  -target=module.resource_group \
  -target=module.virtual_network

# Plan specific resource within module
terraform plan -target='module.storage_account.azurerm_storage_account.this["main"]'
```

### Debugging

```bash
# Enable debug logging
export TF_LOG=DEBUG
terraform plan

# Log to file
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform-debug.log
terraform plan

# Disable logging
unset TF_LOG
unset TF_LOG_PATH

# Show provider configuration
terraform providers

# Show required providers
terraform version
```

## Troubleshooting

### Issue: "Error: Backend initialization required"

**Solution:**
```bash
terraform init
```

### Issue: "Error: Variables must be set"

**Solution:**
```bash
# Make sure you're passing tfvars files
terraform plan -var-file="environments/dev/resource-groups.tfvars"

# Or set via environment variables
export TF_VAR_resource_groups='{"primary": {"name": "test-rg", "location": "East US"}}'
```

### Issue: "Error: Subscription not found"

**Solution:**
```bash
# Re-authenticate
az login

# Set correct subscription
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Verify
az account show
```

### Issue: "Error: Insufficient permissions"

**Solution:**
```bash
# Check current user/SP permissions
az role assignment list --assignee $(az account show --query user.name -o tsv)

# Assign Contributor role if needed
az role assignment create \
  --assignee USER_OR_SP \
  --role Contributor \
  --scope /subscriptions/SUBSCRIPTION_ID
```

### Issue: "Error: Resource already exists"

**Solution:**
```bash
# Import existing resource
terraform import module.resource_group.azurerm_resource_group.this["primary"] /subscriptions/SUB_ID/resourceGroups/RG_NAME

# Or use terraform state to manage
terraform state list
terraform state show 'module.resource_group.azurerm_resource_group.this["primary"]'
```

### Issue: "Error: Terraform version mismatch"

**Solution:**
```bash
# Check required version
cat main.tf | grep required_version

# Upgrade terraform
# Download from: https://www.terraform.io/downloads

# Or use tfenv (version manager)
tfenv install 1.14.4
tfenv use 1.14.4
```

### Issue: Variables file not found

**Solution:**
```bash
# Check file exists
ls -la environments/dev/*.tfvars

# Use absolute or relative paths correctly
terraform plan -var-file="./environments/dev/resource-groups.tfvars"

# Use shell expansion for all files
terraform plan $(for f in environments/dev/*.tfvars; do echo "-var-file=$f"; done)
```

## Quick Testing Scripts

### Create test-dev.sh

```bash
#!/bin/bash
# test-dev.sh - Test dev environment

set -e

echo "Initializing Terraform..."
terraform init

echo "Validating configuration..."
terraform validate

echo "Planning dev environment..."
terraform plan \
  $(for f in environments/dev/*.tfvars; do echo "-var-file=$f"; done) \
  -out=dev.tfplan

echo "Plan saved to dev.tfplan"
echo "Review with: terraform show dev.tfplan"
echo "Apply with: terraform apply dev.tfplan"
```

### Create test-module.sh

```bash
#!/bin/bash
# test-module.sh - Test specific module

MODULE=${1:-resource-group}

echo "Testing module: $MODULE"
cd "modules/$MODULE"

terraform init
terraform validate
terraform fmt -check

if [ -f "example/terraform.tfvars" ]; then
  terraform plan -var-file="example/terraform.tfvars"
fi

cd ../..
echo "Module $MODULE test complete"
```

### Make scripts executable

```bash
chmod +x test-dev.sh test-module.sh

# Run tests
./test-dev.sh
./test-module.sh storage-account
```

## Best Practices

1. **Always validate before plan**
   ```bash
   terraform validate && terraform plan
   ```

2. **Use workspace for multiple environments**
   ```bash
   terraform workspace new dev
   terraform workspace new staging
   terraform workspace new production
   terraform workspace select dev
   ```

3. **Review plans before applying**
   ```bash
   terraform plan -out=tfplan
   terraform show tfplan  # Review carefully
   terraform apply tfplan
   ```

4. **Use version control**
   ```bash
   git status
   git diff
   git add .
   git commit -m "Update tfvars"
   ```

5. **Test with minimal resources first**
   - Start with just resource groups
   - Add networking
   - Add other resources incrementally

6. **Use `-refresh=false` for faster testing**
   ```bash
   terraform plan -refresh=false  # Skip state refresh
   ```

7. **Lock state file to prevent conflicts**
   - Use Azure Storage backend with state locking
   - Don't run multiple plans/applies simultaneously

## Next Steps

- Review [DEPENDENCIES.md](DEPENDENCIES.md) for resource dependencies
- Check [MODULAR-TFVARS-GUIDE.md](MODULAR-TFVARS-GUIDE.md) for tfvars structure
- See [README.md](README.md) for general usage

## Support

If you encounter issues:
1. Check Terraform logs with `TF_LOG=DEBUG`
2. Review Azure portal for resource status
3. Check Azure Activity Log for errors
4. Verify authentication with `az account show`
5. Ensure tfvars files have correct structure
