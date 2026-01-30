# GitHub Actions Self-Hosted Runners on Azure

Terraform modules for deploying self-hosted GitHub Actions runners on Azure with multiple deployment options.

## 📋 Table of Contents

- [Overview](#overview)
- [Runner Types](#runner-types)
- [Architecture](#architecture)
- [Quick Start](#quick-start)
- [Modules](#modules)
- [Usage](#usage)
- [Configuration](#configuration)
- [Best Practices](#best-practices)

## Overview

This infrastructure-as-code project provides Terraform modules to deploy self-hosted GitHub Actions runners on Azure infrastructure. It supports multiple deployment patterns for different use cases.

### Why Self-Hosted Runners?

**Benefits:**
- ✅ Better performance with powerful VMs
- ✅ Access to private networks and resources
- ✅ Custom software and tools pre-installed
- ✅ Cost optimization for high-volume CI/CD
- ✅ Compliance and security requirements
- ✅ Faster builds with caching and proximity

**Use Cases:**
- Enterprise CI/CD pipelines
- Private network access requirements
- Heavy computational workloads
- Specialized hardware/software needs
- Cost-sensitive high-volume builds

## Runner Types

### 1. **Linux VM Runners** (`runner-vm-linux`)
Single Linux VM with GitHub Actions runner installed.

**Best For:**
- General purpose CI/CD
- Docker builds
- Linux-based applications
- Development and testing

**Specs:**
- OS: Ubuntu 20.04/22.04
- Sizes: B2s to E64s
- Ephemeral or persistent runners
- Pre-installed: Docker, Azure CLI, common tools

### 2. **Windows VM Runners** (`runner-vm-windows`)
Single Windows Server VM with GitHub Actions runner.

**Best For:**
- .NET applications
- Windows-specific builds
- PowerShell automation
- Legacy Windows applications

**Specs:**
- OS: Windows Server 2019/2022
- Sizes: D2s to E64s
- .NET Framework/Core support
- Pre-installed: Visual Studio Build Tools, PowerShell

### 3. **Linux VMSS Runners** (`runner-vmss-linux`)
Auto-scaling VM Scale Set for Linux runners.

**Best For:**
- High-volume CI/CD
- Variable workload
- Cost optimization with auto-scaling
- Ephemeral runners

**Features:**
- Auto-scaling: 0-100 instances
- Ephemeral runners (destroyed after each job)
- Load-based scaling
- Cost-effective for variable loads

### 4. **Windows VMSS Runners** (`runner-vmss-windows`)
Auto-scaling VM Scale Set for Windows runners.

**Best For:**
- High-volume Windows builds
- Variable .NET workloads
- Enterprise CI/CD at scale

**Features:**
- Auto-scaling: 0-50 instances
- Ephemeral runners
- Windows Server 2019/2022
- Build tools pre-installed

### 5. **Container Instance Runners** (`runner-container-instance`)
Serverless Docker container runners.

**Best For:**
- Occasional builds
- Serverless CI/CD
- Quick startup times
- Cost-effective for low volume

**Features:**
- No VM management
- Pay-per-second billing
- Fast startup (seconds)
- Docker-based workflow

### 6. **Docker Host Runners** (`runner-docker-host`)
Linux VM running multiple Docker container runners.

**Best For:**
- Multiple isolated runners on single VM
- Resource optimization
- Development environments
- Team workflows

**Features:**
- Multiple runners per VM
- Docker Compose management
- Resource limits per container
- Easy scaling

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         GitHub                                   │
│                    (Actions Workflows)                          │
└─────────────────┬──────────────────────────────────────────────┘
                  │
                  │ Runner API
                  │ (Runner Registration & Job Queue)
                  │
    ┌─────────────┴──────────────┬──────────────┬────────────────┐
    │                            │              │                │
    ▼                            ▼              ▼                ▼
┌────────────┐            ┌────────────┐  ┌─────────────┐  ┌────────────┐
│ Linux VM   │            │ Windows VM │  │  VMSS       │  │ Containers │
│ Runners    │            │ Runners    │  │  (Auto-    │  │ (ACI/      │
│            │            │            │  │   scale)    │  │  Docker)   │
│ • Ubuntu   │            │ • Win 2022 │  │             │  │            │
│ • Docker   │            │ • .NET     │  │ • Linux     │  │ • Serverless│
│ • Azure CLI│            │ • VS Build │  │ • Windows   │  │ • Fast     │
└────────────┘            └────────────┘  └─────────────┘  └────────────┘
      │                         │                │                │
      └─────────────────────────┴────────────────┴────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
              ┌─────▼──────┐          ┌──────▼─────┐
              │   VNet     │          │  Storage   │
              │  (Private  │          │  (Artifacts,│
              │  Network)  │          │   Cache)   │
              └────────────┘          └────────────┘
```

### Network Architecture

```
Azure Subscription
│
├── Resource Group: runners-rg
│   │
│   ├── Virtual Network: runners-vnet
│   │   ├── Subnet: runners-subnet (for VMs/VMSS)
│   │   ├── Subnet: containers-subnet (for ACI)
│   │   └── NSG: runners-nsg
│   │
│   ├── VMs/VMSS: Runner instances
│   ├── Storage Account: Runner cache/artifacts
│   ├── Key Vault: Secrets and PAT tokens
│   └── Log Analytics: Monitoring and logs
```

## Quick Start

### Prerequisites

1. **GitHub Personal Access Token (PAT)**
   - Repo scope or Admin:org scope
   - Used to register runners
   
   ```bash
   # Create token at: https://github.com/settings/tokens
   # Required scopes:
   # - repo (for repository runners)
   # - admin:org (for organization runners)
   ```

2. **Azure Subscription**
   ```bash
   az login
   az account set --subscription "YOUR_SUBSCRIPTION"
   ```

3. **Terraform** (>= 1.14.0)
   ```bash
   terraform version
   ```

### Deploy Linux VM Runner

```bash
cd github-actions-runners

# Initialize
terraform init

# Plan
terraform plan \
  -var-file="environments/dev/runner-vm-linux.tfvars"

# Apply
terraform apply \
  -var-file="environments/dev/runner-vm-linux.tfvars"
```

### Register Runner with GitHub

```bash
# Runner will auto-register using PAT from Key Vault
# Check GitHub: Settings → Actions → Runners

# Or manually register
./scripts/register-runner.sh \
  --token "YOUR_PAT" \
  --url "https://github.com/YOUR_ORG/YOUR_REPO" \
  --name "azure-linux-runner-1"
```

## Modules

### Module: runner-vm-linux

**Single Linux VM runner for GitHub Actions.**

**Features:**
- Ubuntu 20.04 or 22.04
- Docker pre-installed
- Azure CLI, Git, common tools
- Managed or unmanaged disks
- Public or private IP
- Auto-registration with GitHub

**Usage:**
```hcl
module "linux_runner" {
  source = "./modules/runner-vm-linux"
  
  runners = {
    "primary" = {
      name                = "linux-runner-1"
      resource_group_name = "runners-rg"
      location            = "East US"
      vm_size             = "Standard_D2s_v3"
      admin_username      = "azureuser"
      github_url          = "https://github.com/myorg"
      github_token        = var.github_pat
      runner_labels       = ["azure", "linux", "docker"]
    }
  }
}
```

### Module: runner-vm-windows

**Single Windows Server VM runner.**

**Features:**
- Windows Server 2019 or 2022
- Visual Studio Build Tools
- .NET Framework & Core
- PowerShell 7
- Auto-registration

**Usage:**
```hcl
module "windows_runner" {
  source = "./modules/runner-vm-windows"
  
  runners = {
    "primary" = {
      name                = "windows-runner-1"
      resource_group_name = "runners-rg"
      location            = "East US"
      vm_size             = "Standard_D4s_v3"
      admin_username      = "azureuser"
      github_url          = "https://github.com/myorg"
      github_token        = var.github_pat
      runner_labels       = ["azure", "windows", "dotnet"]
    }
  }
}
```

### Module: runner-vmss-linux

**Auto-scaling Linux runners using VM Scale Sets.**

**Features:**
- Auto-scaling: 0-100 instances
- Ephemeral runners (destroyed after job)
- Cost-effective for variable loads
- Multiple runner groups

**Usage:**
```hcl
module "linux_vmss" {
  source = "./modules/runner-vmss-linux"
  
  scale_sets = {
    "production" = {
      name                = "linux-vmss-prod"
      resource_group_name = "runners-rg"
      location            = "East US"
      vm_size             = "Standard_D2s_v3"
      instances_min       = 1
      instances_max       = 10
      github_url          = "https://github.com/myorg"
      github_token        = var.github_pat
    }
  }
}
```

### Module: runner-vmss-windows

**Auto-scaling Windows runners using VM Scale Sets.**

### Module: runner-container-instance

**Serverless runners using Azure Container Instances.**

**Features:**
- No VM management
- Pay-per-second billing
- Fast startup
- Docker-based

### Module: runner-docker-host

**Linux VM hosting multiple Docker container runners.**

**Features:**
- Multiple isolated runners
- Resource limits per container
- Docker Compose management

## Configuration

### Environment Variables

```bash
# GitHub Configuration
export GITHUB_PAT="ghp_..."
export GITHUB_ORG="myorganization"
export GITHUB_REPO="myrepository"

# Azure Configuration
export ARM_SUBSCRIPTION_ID="..."
export ARM_TENANT_ID="..."
export ARM_CLIENT_ID="..."
export ARM_CLIENT_SECRET="..."
```

### tfvars Configuration

See examples in `environments/dev/` for each runner type.

**Example: Linux VM Runner**
```hcl
# environments/dev/runner-vm-linux.tfvars

runners = {
  "dev-runner-1" = {
    name                = "dev-linux-runner-1"
    resource_group_name = "runners-dev-rg"
    location            = "East US"
    vm_size             = "Standard_B2s"
    os_disk_size_gb     = 128
    admin_username      = "azureuser"
    
    github_url          = "https://github.com/myorg"
    github_token        = "GITHUB_PAT_FROM_KEYVAULT"
    runner_group        = "Default"
    runner_labels       = ["azure", "linux", "dev", "docker"]
    
    runner_version      = "latest"
    ephemeral          = false
    
    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
      Purpose     = "GitHub Actions Runner"
    }
  }
}
```

## Best Practices

### Security

1. **Store PAT in Key Vault**
   ```hcl
   github_token = data.azurerm_key_vault_secret.github_pat.value
   ```

2. **Use Private Networking**
   - Deploy runners in private subnets
   - Use Azure Bastion for access
   - Enable NSG rules

3. **Managed Identities**
   - Use for Azure resource access
   - Avoid storing credentials

4. **Ephemeral Runners**
   - Use for production (destroyed after each job)
   - Better security posture
   - Fresh environment every time

### Cost Optimization

1. **Auto-Scaling**
   - Use VMSS with scale-to-zero
   - Scale based on queue depth
   - Use B-series VMs for dev

2. **Spot Instances**
   - 70-90% cost savings
   - Good for non-critical workloads
   - Use with VMSS

3. **Right-Sizing**
   - Start small (B2s, D2s)
   - Monitor CPU/Memory usage
   - Scale up only if needed

### Monitoring

1. **Azure Monitor**
   ```hcl
   enable_monitoring = true
   log_analytics_workspace_id = var.workspace_id
   ```

2. **Key Metrics**
   - CPU utilization
   - Memory usage
   - Disk I/O
   - Network throughput
   - Runner queue depth

3. **Alerts**
   - Runner offline
   - High resource usage
   - Failed registrations

### Maintenance

1. **Regular Updates**
   - Update runner version monthly
   - Update base OS images
   - Patch security vulnerabilities

2. **Runner Rotation**
   - Use ephemeral runners
   - Rotate VMs regularly
   - Fresh installations

3. **Backup Strategy**
   - Backup runner configurations
   - Version control all infrastructure
   - Test disaster recovery

## Comparison Matrix

| Feature | Linux VM | Windows VM | Linux VMSS | Windows VMSS | ACI | Docker Host |
|---------|----------|------------|------------|--------------|-----|-------------|
| **Cost ($/month)** | $50-200 | $100-400 | $20-1000+ | $50-2000+ | $10-100 | $50-150 |
| **Startup Time** | 5 min | 10 min | 3 min | 5 min | 30 sec | 1 min |
| **Auto-Scaling** | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| **Ephemeral** | Optional | Optional | ✅ | ✅ | ✅ | Optional |
| **Concurrent Jobs** | 1-4 | 1-4 | 0-100 | 0-50 | 1 | 5-20 |
| **Docker Support** | ✅ | ⚠️ | ✅ | ⚠️ | ✅ | ✅ |
| **Best For** | Dev/Test | .NET | Production | Enterprise | Serverless | Teams |

## Next Steps

1. Review [module documentation](modules/) for specific configurations
2. Check [example configurations](environments/) for your use case
3. See [scripts](scripts/) for helper automation
4. Read [LOCAL-TESTING.md](../LOCAL-TESTING.md) for testing locally

## Support

- **Issues**: GitHub Issues
- **Documentation**: See module-specific READMEs
- **Examples**: Check `environments/` folder

## License

Same as parent repository.
