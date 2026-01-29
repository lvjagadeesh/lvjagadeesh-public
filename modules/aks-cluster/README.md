# AKS Cluster Terraform Module

## Overview

This is a comprehensive, production-ready Terraform module for deploying Azure Kubernetes Service (AKS) clusters with support for **ALL** possible configuration options from the `azurerm_kubernetes_cluster` resource.

The module includes over **100+ configurable variables** covering all aspects of AKS cluster configuration, making it suitable for enterprise Kubernetes deployments with advanced requirements.

## Features

### Core Features
- ✅ **Automatic Channel Upgrades**: Configure automatic cluster and node OS upgrades
- ✅ **Azure Policy Integration**: Enable Azure Policy for Kubernetes
- ✅ **Private Clusters**: Full support for private AKS clusters with custom DNS
- ✅ **Workload Identity**: OIDC issuer and workload identity support
- ✅ **Image Cleaner**: Automatic cleanup of unused container images
- ✅ **Cost Analysis**: Enable built-in cost analysis
- ✅ **Multiple SKU Tiers**: Support for Free, Standard, and Premium tiers

### Identity & Security
- ✅ **Identity Types**: System-assigned or user-assigned managed identities
- ✅ **Azure AD RBAC**: Full Azure AD integration with RBAC
- ✅ **Local Account Control**: Disable local Kubernetes accounts
- ✅ **Disk Encryption**: Support for customer-managed encryption keys
- ✅ **Microsoft Defender**: Security monitoring integration
- ✅ **Key Vault Integration**: Secrets Provider with rotation support
- ✅ **Confidential Computing**: SGX support for confidential workloads

### Networking
- ✅ **Network Plugins**: Azure CNI, Kubenet, or None
- ✅ **Network Policies**: Azure, Calico, or Cilium
- ✅ **Dual-Stack**: IPv4 and IPv6 support
- ✅ **Load Balancer**: Standard and Basic SKUs with advanced profiles
- ✅ **NAT Gateway**: Managed and user-assigned NAT Gateway support
- ✅ **Outbound Types**: Load balancer, user-defined routing, NAT Gateway
- ✅ **API Server Access**: IP whitelisting and VNet integration
- ✅ **HTTP Proxy**: Full proxy configuration support

### Node Pool Configuration
- ✅ **Auto-scaling**: Horizontal auto-scaling with min/max nodes
- ✅ **Availability Zones**: Multi-zone deployment support
- ✅ **Node Labels & Taints**: Custom Kubernetes labels and taints
- ✅ **OS Options**: Ubuntu, CBL-Mariner, Azure Linux, Windows
- ✅ **Disk Configuration**: Custom OS disk size, type (Managed/Ephemeral)
- ✅ **Ultra SSD**: Support for ultra-performance disks
- ✅ **Host Encryption**: Enable encryption at host
- ✅ **Upgrade Settings**: Control node pool upgrade behavior

### Monitoring & Logging
- ✅ **Azure Monitor**: OMS Agent integration with MSI auth
- ✅ **Monitor Metrics**: Prometheus metrics with custom labels
- ✅ **Log Analytics**: Workspace integration for logs

### Add-ons & Extensions
- ✅ **Service Mesh**: Istio service mesh profiles
- ✅ **Web App Routing**: Nginx ingress with Azure DNS integration
- ✅ **Storage Profiles**: Blob, disk, file, and snapshot controllers
- ✅ **Workload Autoscaler**: KEDA and Vertical Pod Autoscaler
- ✅ **Open Service Mesh**: OSM add-on support

### Maintenance & Upgrades
- ✅ **Maintenance Windows**: Scheduled maintenance for cluster and node OS
- ✅ **Auto-upgrade Windows**: Control when automatic upgrades occur
- ✅ **Upgrade Exclusions**: Define blackout periods

### Auto-scaler Configuration
- ✅ **15+ Auto-scaler Settings**: Fine-tune cluster autoscaler behavior
- ✅ **Node Provisioning**: Control max provisioning time
- ✅ **Scale Down Policies**: Customizable scale-down behavior
- ✅ **Expander Strategies**: Choose how new nodes are selected

## Usage

### Minimal Example

```hcl
module "aks" {
  source = "./modules/aks-cluster"

  cluster_name        = "my-aks-cluster"
  location            = "eastus"
  resource_group_name = "my-resource-group"
  dns_prefix          = "myaks"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Production Example with Advanced Features

```hcl
module "aks" {
  source = "./modules/aks-cluster"

  # Core Configuration
  cluster_name        = "production-aks"
  location            = "eastus"
  resource_group_name = "aks-production-rg"
  dns_prefix          = "prodaks"
  kubernetes_version  = "1.28.0"
  sku_tier            = "Standard"

  # Upgrades
  automatic_channel_upgrade = "stable"
  node_os_channel_upgrade   = "SecurityPatch"

  # Security & Compliance
  azure_policy_enabled   = true
  local_account_disabled = true
  
  # Private Cluster
  private_cluster_enabled = true
  private_dns_zone_id     = "System"

  # Workload Identity
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Default Node Pool
  default_node_pool_name    = "system"
  default_node_pool_vm_size = "Standard_D4s_v3"
  enable_auto_scaling       = true
  min_node_count            = 3
  max_node_count            = 10
  default_node_pool_zones   = ["1", "2", "3"]
  
  default_node_pool_node_labels = {
    role = "system"
  }

  # Networking
  network_plugin = "azure"
  network_policy = "azure"
  service_cidr   = "10.0.0.0/16"
  dns_service_ip = "10.0.0.10"

  # API Server Access
  api_server_access_profile = {
    authorized_ip_ranges = ["203.0.113.0/24"]
  }

  # Auto-scaler Profile
  auto_scaler_profile = {
    balance_similar_node_groups      = true
    expander                         = "least-waste"
    max_graceful_termination_sec     = 600
    scale_down_delay_after_add       = "10m"
    scale_down_unneeded              = "10m"
    scale_down_utilization_threshold = 0.5
  }

  # Azure AD RBAC
  azure_active_directory_role_based_access_control = {
    managed            = true
    azure_rbac_enabled = true
    admin_group_object_ids = [
      "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    ]
  }

  # Monitoring
  oms_agent = {
    log_analytics_workspace_id      = "/subscriptions/.../workspaces/my-workspace"
    msi_auth_for_monitoring_enabled = true
  }

  # Microsoft Defender
  microsoft_defender = {
    log_analytics_workspace_id = "/subscriptions/.../workspaces/my-workspace"
  }

  # Key Vault Secrets Provider
  key_vault_secrets_provider = {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  # Storage Profile
  storage_profile = {
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }

  # Maintenance Windows
  maintenance_window_auto_upgrade = {
    frequency   = "Weekly"
    interval    = 1
    duration    = 4
    day_of_week = 0 # Sunday
    start_time  = "00:00"
    utc_offset  = "+00:00"
    
    not_allowed = [{
      start = "2024-12-20T00:00:00Z"
      end   = "2024-12-27T00:00:00Z"
    }]
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    CostCenter  = "engineering"
  }
}
```

### Private Cluster with VNet Integration

```hcl
module "aks" {
  source = "./modules/aks-cluster"

  cluster_name        = "private-aks"
  location            = "eastus"
  resource_group_name = "private-aks-rg"
  dns_prefix_private_cluster = "privateaks"

  private_cluster_enabled = true
  private_dns_zone_id     = azurerm_private_dns_zone.aks.id

  api_server_access_profile = {
    vnet_integration_enabled = true
    subnet_id                = azurerm_subnet.aks_api.id
  }

  default_node_pool_vnet_subnet_id = azurerm_subnet.aks_nodes.id
  
  network_plugin = "azure"
  service_cidr   = "10.0.0.0/16"
  dns_service_ip = "10.0.0.10"

  tags = {
    Environment = "production"
  }
}
```

### Windows Node Pool Support

```hcl
module "aks" {
  source = "./modules/aks-cluster"

  cluster_name        = "windows-aks"
  location            = "eastus"
  resource_group_name = "windows-aks-rg"
  dns_prefix          = "winaks"

  # Windows Profile for Windows node pools
  windows_profile = {
    admin_username = "azureuser"
    admin_password = var.windows_admin_password # Sensitive
    license        = "Windows_Server"
  }

  network_plugin = "azure"

  tags = {
    Environment = "production"
  }
}
```

### HTTP Proxy Configuration

```hcl
module "aks" {
  source = "./modules/aks-cluster"

  cluster_name        = "proxy-aks"
  location            = "eastus"
  resource_group_name = "proxy-aks-rg"
  dns_prefix          = "proxyaks"

  http_proxy_config = {
    http_proxy  = "http://proxy.example.com:8080"
    https_proxy = "http://proxy.example.com:8443"
    no_proxy = [
      "localhost",
      "127.0.0.1",
      ".svc.cluster.local"
    ]
    trusted_ca = filebase64("ca-bundle.crt")
  }

  tags = {
    Environment = "restricted"
  }
}
```

### Service Mesh with Istio

```hcl
module "aks" {
  source = "./modules/aks-cluster"

  cluster_name        = "mesh-aks"
  location            = "eastus"
  resource_group_name = "mesh-aks-rg"
  dns_prefix          = "meshaks"

  service_mesh_profile = {
    mode                             = "Istio"
    internal_ingress_gateway_enabled = true
    external_ingress_gateway_enabled = true
  }

  tags = {
    Environment = "production"
  }
}
```

## Input Variables

### Required Variables

| Name | Type | Description |
|------|------|-------------|
| `cluster_name` | `string` | Name of the AKS cluster (1-63 chars, alphanumeric and hyphens) |
| `location` | `string` | Azure region where the cluster will be created |
| `resource_group_name` | `string` | Name of the resource group |

### Core Configuration Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `dns_prefix` | `string` | `null` | DNS prefix for the cluster |
| `dns_prefix_private_cluster` | `string` | `null` | DNS prefix for private cluster |
| `kubernetes_version` | `string` | `"1.27.0"` | Kubernetes version |
| `sku_tier` | `string` | `"Free"` | SKU tier: Free, Standard, Premium |
| `automatic_channel_upgrade` | `string` | `null` | Upgrade channel: patch, rapid, node-image, stable, none |
| `node_os_channel_upgrade` | `string` | `null` | Node OS upgrade: NodeImage, None, Unmanaged, SecurityPatch |
| `azure_policy_enabled` | `bool` | `false` | Enable Azure Policy |
| `disk_encryption_set_id` | `string` | `null` | Disk encryption set ID |
| `http_application_routing_enabled` | `bool` | `false` | Enable HTTP application routing |
| `image_cleaner_enabled` | `bool` | `false` | Enable image cleaner |
| `image_cleaner_interval_hours` | `number` | `48` | Image cleaner interval |
| `local_account_disabled` | `bool` | `false` | Disable local accounts |
| `oidc_issuer_enabled` | `bool` | `false` | Enable OIDC issuer |
| `open_service_mesh_enabled` | `bool` | `false` | Enable Open Service Mesh |
| `private_cluster_enabled` | `bool` | `false` | Enable private cluster |
| `private_dns_zone_id` | `string` | `null` | Private DNS zone ID |
| `private_cluster_public_fqdn_enabled` | `bool` | `false` | Enable public FQDN for private cluster |
| `run_command_enabled` | `bool` | `true` | Enable run command |
| `workload_identity_enabled` | `bool` | `false` | Enable workload identity |
| `support_plan` | `string` | `"KubernetesOfficial"` | Support plan type |
| `cost_analysis_enabled` | `bool` | `false` | Enable cost analysis |

### Default Node Pool Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `default_node_pool_name` | `string` | `"default"` | Node pool name (1-12 chars) |
| `default_node_pool_vm_size` | `string` | `"Standard_D2_v2"` | VM size |
| `default_node_pool_count` | `number` | `3` | Initial node count |
| `enable_auto_scaling` | `bool` | `true` | Enable auto-scaling |
| `min_node_count` | `number` | `1` | Minimum node count |
| `max_node_count` | `number` | `5` | Maximum node count |
| `default_node_pool_zones` | `list(string)` | `null` | Availability zones |
| `default_node_pool_enable_host_encryption` | `bool` | `false` | Enable host encryption |
| `default_node_pool_enable_node_public_ip` | `bool` | `false` | Enable public IP on nodes |
| `default_node_pool_max_pods` | `number` | `30` | Max pods per node |
| `default_node_pool_node_labels` | `map(string)` | `{}` | Node labels |
| `default_node_pool_node_taints` | `list(string)` | `[]` | Node taints |
| `default_node_pool_os_disk_size_gb` | `number` | `128` | OS disk size |
| `default_node_pool_os_disk_type` | `string` | `"Managed"` | OS disk type |
| `default_node_pool_os_sku` | `string` | `"Ubuntu"` | OS SKU |
| `default_node_pool_vnet_subnet_id` | `string` | `null` | VNet subnet ID |
| `default_node_pool_pod_subnet_id` | `string` | `null` | Pod subnet ID |
| `default_node_pool_ultra_ssd_enabled` | `bool` | `false` | Enable Ultra SSD |

### Network Profile Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `network_plugin` | `string` | `"azure"` | Network plugin: azure, kubenet, none |
| `network_mode` | `string` | `null` | Network mode: transparent, bridge |
| `network_policy` | `string` | `null` | Network policy: azure, calico, cilium |
| `network_plugin_mode` | `string` | `null` | Network plugin mode: overlay |
| `dns_service_ip` | `string` | `null` | DNS service IP |
| `service_cidr` | `string` | `null` | Service CIDR |
| `service_cidrs` | `list(string)` | `null` | Service CIDRs for dual-stack |
| `pod_cidr` | `string` | `null` | Pod CIDR |
| `pod_cidrs` | `list(string)` | `null` | Pod CIDRs for dual-stack |
| `ip_versions` | `list(string)` | `["IPv4"]` | IP versions |
| `outbound_type` | `string` | `"loadBalancer"` | Outbound routing method |
| `load_balancer_sku` | `string` | `"standard"` | Load balancer SKU |
| `load_balancer_profile` | `object` | `null` | Load balancer profile config |
| `nat_gateway_profile` | `object` | `null` | NAT gateway profile config |

### Complex Object Variables

See the module's `variables.tf` file for detailed structure of the following complex objects:
- `api_server_access_profile`
- `auto_scaler_profile`
- `azure_active_directory_role_based_access_control`
- `http_proxy_config`
- `identity_type` and `identity_ids`
- `key_management_service`
- `key_vault_secrets_provider`
- `kubelet_identity`
- `linux_profile`
- `maintenance_window`
- `maintenance_window_auto_upgrade`
- `maintenance_window_node_os`
- `microsoft_defender`
- `monitor_metrics`
- `oms_agent`
- `service_mesh_profile`
- `storage_profile`
- `web_app_routing`
- `windows_profile`
- `workload_autoscaler_profile`
- `confidential_computing`

## Outputs

### Basic Outputs

| Name | Description |
|------|-------------|
| `cluster_id` | The ID of the AKS cluster |
| `cluster_name` | The name of the AKS cluster |
| `location` | The Azure region of the cluster |
| `kubernetes_version` | The Kubernetes version |
| `fqdn` | The FQDN of the cluster |
| `private_fqdn` | The private FQDN (for private clusters) |

### Authentication Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `kube_config` | Raw Kubernetes configuration | Yes |
| `kube_config_raw` | Raw kube config string | Yes |
| `kube_admin_config` | Admin Kubernetes configuration | Yes |
| `kube_admin_config_raw` | Raw admin config string | Yes |

### Identity Outputs

| Name | Description |
|------|-------------|
| `identity_principal_id` | Principal ID of the managed identity |
| `identity_tenant_id` | Tenant ID of the managed identity |
| `kubelet_identity_client_id` | Client ID of kubelet identity |
| `kubelet_identity_object_id` | Object ID of kubelet identity |

### Advanced Outputs

| Name | Description |
|------|-------------|
| `node_resource_group` | Auto-generated node resource group |
| `oidc_issuer_url` | OIDC issuer URL for workload identity |
| `key_vault_secrets_provider_identity` | KV secrets provider identity |
| `oms_agent_identity` | OMS agent identity |
| `network_profile` | Complete network profile |
| `storage_profile` | Storage profile configuration |
| `cluster` | Complete cluster object (sensitive) |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Best Practices

### Security
1. **Always enable workload identity** for modern authentication
2. **Use private clusters** for production workloads
3. **Enable Azure Policy** for compliance
4. **Disable local accounts** when using Azure AD
5. **Enable disk encryption** with customer-managed keys
6. **Use Microsoft Defender** for security monitoring

### Networking
1. **Use Azure CNI** for production workloads
2. **Enable network policies** (Azure or Calico)
3. **Configure API server access** with IP restrictions
4. **Use NAT Gateway** for predictable outbound IPs
5. **Plan your CIDR ranges** carefully to avoid conflicts

### Node Pools
1. **Enable auto-scaling** for flexibility
2. **Use availability zones** for high availability
3. **Set appropriate max pods** per node based on network plugin
4. **Use appropriate VM sizes** for your workload
5. **Apply node taints** for workload isolation

### Maintenance
1. **Configure maintenance windows** for predictable updates
2. **Use stable upgrade channel** for production
3. **Enable automatic node OS updates** for security
4. **Set appropriate not_allowed periods** during critical times

### Monitoring
1. **Enable OMS agent** for Azure Monitor integration
2. **Use MSI auth** for monitoring
3. **Enable Monitor Metrics** for Prometheus
4. **Configure Log Analytics** workspace

### Cost Optimization
1. **Enable cost analysis** for visibility
2. **Use auto-scaling** to optimize node count
3. **Configure appropriate auto-scaler profile** for efficiency
4. **Choose appropriate SKU tier** based on requirements

## Migration Guide

### From Basic to Advanced Configuration

If you're currently using the basic module, you can migrate gradually:

1. **Start with security features**: Enable workload identity, Azure Policy
2. **Add monitoring**: Configure OMS agent and Microsoft Defender
3. **Enhance networking**: Add API server access controls
4. **Configure maintenance**: Set up maintenance windows
5. **Fine-tune auto-scaling**: Configure auto-scaler profile

All new variables have sensible defaults, ensuring backward compatibility.

## Troubleshooting

### Common Issues

**Issue**: Cluster fails to create with network plugin errors
- **Solution**: Ensure `service_cidr` and `dns_service_ip` are properly configured and don't conflict with VNet

**Issue**: Private cluster cannot be accessed
- **Solution**: Ensure you have proper VPN/ExpressRoute connectivity to the VNet

**Issue**: Workload identity not working
- **Solution**: Ensure both `oidc_issuer_enabled` and `workload_identity_enabled` are set to `true`

**Issue**: Auto-scaling not working as expected
- **Solution**: Check `auto_scaler_profile` settings, especially `scale_down_delay_after_add` and `scale_down_unneeded`

## Support

For issues, questions, or contributions, please refer to the main repository documentation.

## License

This module is released under the MIT License.

## Authors

Module managed by the platform engineering team.

## Changelog

### v2.0.0 (Latest)
- ✅ Added 100+ new configuration variables
- ✅ Support for all azurerm_kubernetes_cluster arguments
- ✅ Comprehensive dynamic blocks for optional features
- ✅ Enhanced outputs with 40+ output values
- ✅ Full backward compatibility maintained
- ✅ Production-ready validation rules
- ✅ Enterprise-grade documentation

### v1.0.0
- Initial release with basic AKS cluster support
