# GitHub Actions Runner - Linux VM Module

This module creates GitHub Actions self-hosted runners on Linux Virtual Machines in Azure.

## Features

- ✅ Ubuntu 22.04 LTS VMs
- ✅ Pre-installed Docker and common tools
- ✅ Automatic runner registration with GitHub
- ✅ Support for Azure Spot instances
- ✅ Configurable VM sizes
- ✅ Custom runner labels
- ✅ Network isolation support
- ✅ Boot diagnostics enabled

## Usage

```hcl
module "runner_vm_linux" {
  source = "./modules/runner-vm-linux"
  
  runners = {
    "runner-1" = {
      name                = "gh-runner-linux-01"
      location            = "East US"
      resource_group_name = "runners-rg"
      vm_size             = "Standard_D2s_v3"
      
      github_url          = "https://github.com/myorg/myrepo"
      github_token        = var.github_token
      runner_labels       = ["self-hosted", "linux", "x64", "docker"]
      
      subnet_id           = azurerm_subnet.runners.id
      public_ip_enabled   = false
      
      tags = {
        Environment = "Production"
        Purpose     = "CI/CD"
      }
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.0 |
| azurerm | ~> 4.58 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 4.58 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| runners | Map of runners to create | `map(object)` | n/a | yes |

### Runner Object Properties

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | VM name | `string` | n/a | yes |
| location | Azure location | `string` | n/a | yes |
| resource_group_name | Resource group name | `string` | n/a | yes |
| vm_size | VM size | `string` | `"Standard_D2s_v3"` | no |
| admin_username | Admin username | `string` | `"azureuser"` | no |
| os_disk_size_gb | OS disk size in GB | `number` | `30` | no |
| os_disk_type | OS disk type | `string` | `"Premium_LRS"` | no |
| github_url | GitHub repository or organization URL | `string` | n/a | yes |
| github_token | GitHub Personal Access Token | `string` | n/a | yes |
| runner_group | GitHub runner group | `string` | `"Default"` | no |
| runner_labels | Runner labels | `list(string)` | `["self-hosted", "linux", "x64"]` | no |
| subnet_id | Subnet ID for the VM | `string` | n/a | yes |
| public_ip_enabled | Enable public IP | `bool` | `false` | no |
| enable_spot_instance | Use Azure Spot instance | `bool` | `false` | no |
| spot_eviction_policy | Spot eviction policy | `string` | `"Deallocate"` | no |
| spot_max_bid_price | Maximum bid price for spot | `number` | `-1` (pay up to on-demand) | no |
| enable_boot_diagnostics | Enable boot diagnostics | `bool` | `true` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| runners | Complete runner information map |
| runner_ids | Map of runner IDs |
| runner_names | Map of runner names |
| runner_private_ips | Map of private IP addresses |
| runner_public_ips | Map of public IP addresses |

## VM Sizes

Recommended VM sizes for GitHub Actions runners:

| Size | vCPUs | RAM | Cost/Month | Best For |
|------|-------|-----|------------|----------|
| Standard_B2s | 2 | 4 GB | ~$30 | Light workloads |
| Standard_D2s_v3 | 2 | 8 GB | ~$70 | General purpose |
| Standard_D4s_v3 | 4 | 16 GB | ~$140 | Heavy builds |
| Standard_F4s_v2 | 4 | 8 GB | ~$130 | Compute intensive |

## Notes

- GitHub token requires `repo` and `admin:org` scopes for runner registration
- Runners auto-register on VM startup via cloud-init
- Spot instances can be deallocated at any time - use for non-critical workloads
- Boot diagnostics logs are stored in the diagnostic storage account

## Example

See `example/terraform.tfvars` for complete usage example.
