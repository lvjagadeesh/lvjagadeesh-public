# Azure Container Registry Terraform Module

This Terraform module creates and manages Azure Container Registries with comprehensive support for ALL available configuration options from the official AzureRM provider.

## Features

This module supports all features of the `azurerm_container_registry` resource including:

### Core Configuration
- **SKU Selection**: Basic, Standard, or Premium tiers
- **Admin Access**: Optional admin user credentials
- **Public Network Access**: Control public accessibility
- **Quarantine Policy**: Enable quarantine for images (Premium SKU)
- **Zone Redundancy**: High availability with zone redundancy (Premium SKU)
- **Export Policy**: Control image export permissions
- **Anonymous Pull**: Allow anonymous pull access
- **Data Endpoints**: Dedicated data endpoints for performance (Premium SKU)
- **Network Rule Bypass**: Allow trusted Azure services

### Geo-Replication (Premium SKU)
- Multiple geo-replications across Azure regions
- Zone redundancy per replication
- Regional endpoint configuration
- Per-replication tagging

### Network Security
- Network rule sets with default action
- IP-based access rules
- Configurable default action (Allow/Deny)

### Data Management (Premium SKU)
- **Retention Policy**: Configure retention period for untagged manifests (0-365 days)
- **Trust Policy**: Enable content trust for signed images

### Identity & Encryption
- **Managed Identity**: System-assigned or user-assigned identities
- **Customer-Managed Keys**: Encrypt registry data with your own keys (Premium SKU)

## Usage

### Basic Example

```hcl
module "container_registry" {
  source = "./modules/container-registry"

  container_registries = {
    "my_registry" = {
      name                = "myregistryname"
      resource_group_name = "my-resource-group"
      location            = "East US"
      sku                 = "Standard"
      admin_enabled       = false
      tags = {
        Environment = "Development"
        ManagedBy   = "Terraform"
      }
    }
  }
}
```

### Multiple Container Registries Example

```hcl
module "container_registry" {
  source = "./modules/container-registry"

  container_registries = {
    "dev_registry" = {
      name                = "devacr12345"
      resource_group_name = "example-rg"
      location            = "East US"
      sku                 = "Basic"
      admin_enabled       = true
      tags = {
        Environment = "Development"
        ManagedBy   = "Terraform"
      }
    }

    "prod_registry" = {
      name                = "prodacr12345"
      resource_group_name = "example-rg"
      location            = "East US"
      sku                 = "Premium"
      admin_enabled       = false
      zone_redundancy_enabled = true
      tags = {
        Environment = "Production"
        ManagedBy   = "Terraform"
      }
    }
  }
}
```

### Advanced Example with All Features

```hcl
module "container_registry" {
  source = "./modules/container-registry"

  container_registries = {
    "premium_registry" = {
      # Required
      name                = "premiumacr2024"
      resource_group_name = "production-rg"
      location            = "East US"

      # Core configuration
      sku                           = "Premium"
      admin_enabled                 = false
      public_network_access_enabled = true
      quarantine_policy_enabled     = true
      zone_redundancy_enabled       = true
      export_policy_enabled         = true
      anonymous_pull_enabled        = false
      data_endpoint_enabled         = true
      network_rule_bypass_option    = "AzureServices"

      # Geo-replications
      georeplications = [
        {
          location                  = "West US"
          zone_redundancy_enabled   = true
          regional_endpoint_enabled = false
          tags = {
            ReplicaLocation = "west"
          }
        }
      ]

      # Network rules
      network_rule_set = {
        default_action = "Deny"
        ip_rule = [
          {
            action   = "Allow"
            ip_range = "203.0.113.0/24"
          }
        ]
      }

      # Retention and trust policies
      retention_policy_in_days = 7
      trust_policy_enabled     = true

      # Managed identity
      identity = {
        type = "SystemAssigned"
      }

      # Customer-managed encryption
      encryption = {
        key_vault_key_id   = "https://example-vault.vault.azure.net/keys/example-key/version"
        identity_client_id = "00000000-0000-0000-0000-000000000000"
      }

      tags = {
        Environment = "Production"
        ManagedBy   = "Terraform"
      }
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| azurerm | ~> 4.58 |

## Inputs

### Required Input

| Name | Description | Type |
|------|-------------|------|
| `container_registries` | Map of container registries to create. Each key is a unique identifier and value contains the container registry configuration | `map(object)` |

### Container Registry Configuration Object

Each entry in `container_registries` map supports the following attributes:

#### Required Attributes

| Name | Description | Type |
|------|-------------|------|
| `name` | Name of the Container Registry. Must be globally unique, 5-50 characters, alphanumeric only | `string` |
| `resource_group_name` | Name of the resource group where the Container Registry will be created | `string` |
| `location` | Azure region where the Container Registry will be created | `string` |

#### Optional Attributes

| Name | Description | Type | Default | SKU Requirement |
|------|-------------|------|---------|-----------------|
| `sku` | SKU for the Container Registry. Valid values: Basic, Standard, Premium | `string` | `"Standard"` | All |
| `admin_enabled` | Enable admin user for the registry | `bool` | `false` | All |
| `public_network_access_enabled` | Whether public network access is allowed | `bool` | `true` | All |
| `quarantine_policy_enabled` | Enable quarantine policy for images | `bool` | `false` | Premium |
| `zone_redundancy_enabled` | Enable zone redundancy (can only be set at creation) | `bool` | `false` | Premium |
| `export_policy_enabled` | Enable export policy | `bool` | `true` | All |
| `anonymous_pull_enabled` | Allow anonymous pull access | `bool` | `false` | All |
| `data_endpoint_enabled` | Enable dedicated data endpoints | `bool` | `false` | Premium |
| `network_rule_bypass_option` | Allow trusted Azure services. Values: AzureServices, None | `string` | `"AzureServices"` | All |
| `georeplications` | List of geo-replication configurations | `list(object)` | `[]` | Premium |
| `network_rule_set` | Network rule set configuration | `object` | `null` | All |
| `retention_policy_in_days` | Days to retain untagged manifests (0-365) | `number` | `null` | Premium |
| `trust_policy_enabled` | Enable content trust policy | `bool` | `null` | Premium |
| `identity` | Managed identity configuration | `object` | `null` | All |
| `encryption` | Customer-managed key encryption | `object` | `null` | Premium |
| `tags` | Tags to apply to the Container Registry | `map(string)` | `{}` | All |

### Complex Input Structures

#### georeplications
```hcl
georeplications = [
  {
    location                  = string           # Required
    zone_redundancy_enabled   = bool            # Optional
    regional_endpoint_enabled = bool            # Optional
    tags                      = map(string)     # Optional
  }
]
```

#### network_rule_set
```hcl
network_rule_set = {
  default_action = string  # Optional: "Allow" or "Deny"
  ip_rule = [              # Optional
    {
      action   = string    # Required: Must be "Allow"
      ip_range = string    # Required: IP or CIDR
    }
  ]
}
```

#### identity
```hcl
identity = {
  type         = string       # Required: "SystemAssigned", "UserAssigned", or "SystemAssigned, UserAssigned"
  identity_ids = list(string) # Optional: Required for UserAssigned types
}
```

#### encryption
```hcl
encryption = {
  key_vault_key_id   = string # Required: Key Vault key ID
  identity_client_id = string # Required: Client ID of managed identity
}
```

## Outputs

| Name | Description |
|------|-------------|
| `container_registries` | Map of all container registries created (excluding sensitive data) |
| `container_registry_ids` | Map of container registry keys to IDs |
| `container_registry_names` | Map of container registry keys to names |
| `login_servers` | Map of container registry keys to login server URLs |
| `admin_usernames` | Map of container registry keys to admin usernames (if enabled) |
| `admin_passwords` | Map of container registry keys to admin passwords (if enabled, sensitive) |
| `identity_principal_ids` | Map of container registry keys to identity principal IDs |
| `identity_tenant_ids` | Map of container registry keys to identity tenant IDs |
| `skus` | Map of container registry keys to SKUs |
| `resource_group_names` | Map of container registry keys to resource group names |
| `locations` | Map of container registry keys to locations |
| `public_network_access_enabled` | Map of container registry keys to public network access enabled status |
| `admin_enabled` | Map of container registry keys to admin enabled status |
| `zone_redundancy_enabled` | Map of container registry keys to zone redundancy enabled status |
| `data_endpoint_enabled` | Map of container registry keys to data endpoint enabled status |

## SKU Feature Matrix

| Feature | Basic | Standard | Premium |
|---------|-------|----------|---------|
| Storage (GB) | 10 | 100 | 500 |
| Webhooks | 2 | 10 | 500 |
| Geo-replication | ❌ | ❌ | ✅ |
| Zone redundancy | ❌ | ❌ | ✅ |
| Quarantine policy | ❌ | ❌ | ✅ |
| Data endpoints | ❌ | ❌ | ✅ |
| Retention policy | ❌ | ❌ | ✅ |
| Trust policy | ❌ | ❌ | ✅ |
| Encryption (CMK) | ❌ | ❌ | ✅ |

## Examples

See the `example` directory for:
- `terraform.tfvars` - Multiple container registries with various configurations

## Notes

- **Zone Redundancy**: Can only be set at registry creation time and cannot be modified later
- **Premium Features**: Many advanced features require Premium SKU
- **Global Uniqueness**: Container Registry names must be globally unique across Azure
- **Network Rules**: When using network rules, consider allowing Azure services for functionality
- **Managed Identity**: Required when using customer-managed keys for encryption

## Authors

Module managed by the Terraform team.

## License

This module is provided as-is for use in your infrastructure.
