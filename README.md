# Azure Terraform Infrastructure

Production-ready Azure Terraform infrastructure with modular design, multi-environment support, and automated CI/CD pipelines.

## 📋 Overview

This repository contains Terraform modules and configurations for deploying a complete Azure infrastructure stack. It includes 10 reusable modules covering essential Azure services with best practices for security, scalability, and maintainability.

## 🏗️ Architecture

### Modules

The infrastructure is organized into 10 modular components:

1. **Resource Group** - Base resource organization
2. **Virtual Network** - Network infrastructure with subnets
3. **Storage Account** - Blob storage with security features
4. **Key Vault** - Secrets and key management
5. **App Service Plan** - Hosting plan for web applications
6. **App Service** - Web application hosting
7. **SQL Server** - Managed SQL Server instance
8. **SQL Database** - SQL Database
9. **Container Registry** - Docker container registry
10. **AKS Cluster** - Kubernetes cluster for container orchestration

### Module Structure

Each module follows a consistent structure:

```
modules/<resource-name>/
├── main.tf          # Resource definitions
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── provider.tf      # Provider configuration
└── example/
    └── terraform.tfvars  # Example usage
```

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription with appropriate permissions
- Azure Storage Account for Terraform state (for remote backend)

### Azure Authentication

```bash
# Login to Azure
az login

# Set your subscription
az account set --subscription "<subscription-id>"
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

3. **Select an environment and plan**
   ```bash
   terraform plan -var-file="environments/dev/terraform.tfvars"
   ```

4. **Apply the configuration**
   ```bash
   terraform apply -var-file="environments/dev/terraform.tfvars"
   ```

## 🌍 Environments

Three pre-configured environments are available:

- **dev** - Development environment with minimal resources
- **staging** - Staging environment with moderate resources
- **production** - Production environment with full redundancy and scaling

Each environment has its own tfvars file in `environments/<env>/terraform.tfvars`.

### Environment Configuration

Modify the tfvars files to customize your deployment:

```hcl
# environments/dev/terraform.tfvars
location            = "East US"
resource_group_name = "dev-rg"
vnet_name          = "dev-vnet"
# ... additional variables
```

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

The repository includes a production-ready GitHub Actions workflow that:

- ✅ Validates Terraform syntax and formatting
- 📋 Generates and posts plan results on PRs
- 🚀 Automatically applies changes to dev on main branch
- 🎯 Supports manual deployment to any environment
- 🗑️ Includes destroy workflow for cleanup

### Required Secrets

Configure these secrets in your GitHub repository:

```
AZURE_CLIENT_ID           # Azure Service Principal Client ID
AZURE_TENANT_ID           # Azure Tenant ID
AZURE_SUBSCRIPTION_ID     # Azure Subscription ID
TFSTATE_RESOURCE_GROUP    # Resource group for Terraform state
TFSTATE_STORAGE_ACCOUNT   # Storage account for Terraform state
TFSTATE_CONTAINER         # Container name for Terraform state
```

### Workflow Triggers

- **Push to main/develop** - Validates and plans changes
- **Pull Request** - Validates, plans, and comments results
- **Manual Dispatch** - Deploy to any environment on-demand

## 📦 Module Usage

### Example: Using the Resource Group Module

```hcl
module "resource_group" {
  source = "./modules/resource-group"

  resource_group_name = "my-rg"
  location            = "East US"
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

### Example: Using the Virtual Network Module

```hcl
module "virtual_network" {
  source = "./modules/virtual-network"

  vnet_name           = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = module.resource_group.resource_group_name
  
  subnets = [
    {
      name             = "subnet1"
      address_prefixes = ["10.0.1.0/24"]
    }
  ]
}
```

## 🔒 Security Best Practices

- ✅ TLS 1.2 minimum for all services
- ✅ Managed identities for service authentication
- ✅ Network security rules with deny-by-default
- ✅ Key Vault for secrets management
- ✅ Soft delete and purge protection enabled
- ✅ Storage account encryption at rest
- ✅ SQL Server firewall rules
- ✅ Passwords not hardcoded in tfvars files

### Handling Sensitive Data

**Never commit sensitive data to version control.** The environment tfvars files contain placeholder values for passwords. Before deploying:

1. **Option 1: Use Environment Variables**
   ```bash
   export TF_VAR_sql_administrator_password="YourSecurePassword"
   terraform apply -var-file="environments/dev/terraform.tfvars"
   ```

2. **Option 2: Use Azure Key Vault**
   ```bash
   # Retrieve password from Key Vault
   az keyvault secret show --name sql-admin-password --vault-name your-kv --query value -o tsv
   ```

3. **Option 3: Use GitHub Secrets (for CI/CD)**
   - Store sensitive values as GitHub secrets
   - Reference them in the workflow using `${{ secrets.SQL_ADMIN_PASSWORD }}`

4. **Option 4: Use terraform.tfvars (locally, never commit)**
   ```bash
   # Create a local tfvars file (this file is ignored by .gitignore)
   cat > local-secrets.tfvars <<EOF
   sql_administrator_password = "YourSecurePassword"
   EOF
   
   # Apply with multiple tfvars files
   terraform apply \
     -var-file="environments/dev/terraform.tfvars" \
     -var-file="local-secrets.tfvars"
   ```

## 🔧 Customization

### Adding a New Module

1. Create module directory structure:
   ```bash
   mkdir -p modules/new-resource/{example}
   ```

2. Create the required files:
   - `main.tf` - Resource definitions
   - `variables.tf` - Input variables
   - `outputs.tf` - Output values
   - `provider.tf` - Provider configuration
   - `example/terraform.tfvars` - Example usage

3. Add module call to `main.tf`
4. Add variables to `variables.tf`
5. Add outputs to `outputs.tf`
6. Update environment tfvars files

### Modifying Existing Modules

Each module is self-contained. Modify the module files directly and test using the example tfvars:

```bash
cd modules/resource-group
terraform init
terraform plan -var-file="example/terraform.tfvars"
```

## 📊 Terraform State Management

This configuration uses Azure Storage as a remote backend for state management:

- State files are stored per environment
- State locking prevents concurrent modifications
- Supports team collaboration
- Enables state sharing across pipelines

## 🧹 Cleanup

To destroy resources:

### Using Terraform CLI

```bash
terraform destroy -var-file="environments/dev/terraform.tfvars"
```

### Using GitHub Actions

Trigger the workflow manually with the "destroy" option.

## 📝 Contributing

1. Create a feature branch
2. Make your changes
3. Test locally
4. Create a pull request
5. CI/CD will validate and plan changes
6. Merge after approval

## 📄 License

This project is licensed under the MIT License.

## 🤝 Support

For issues and questions:
- Open an issue in GitHub
- Contact the infrastructure team

## 🔗 Resources

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
