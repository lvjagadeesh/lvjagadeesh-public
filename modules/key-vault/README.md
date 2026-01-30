# Azure Key Vault Terraform Module

This module creates and configures an Azure Key Vault with comprehensive support for all available arguments from the official Terraform AzureRM provider.

## Features

- **Complete Argument Support**: Includes all arguments from `azurerm_key_vault` resource
- **Advanced Networking**: Support for IP rules and VNet subnet restrictions
- **RBAC Authorization**: Optional Role-Based Access Control
- **Multiple Access Policies**: Support for additional access policies beyond the default
- **Certificate Contacts**: Configuration for certificate lifecycle notifications
- **Production-Ready Defaults**: Secure defaults for enterprise use
- **Backward Compatible**: All new arguments are optional

## Usage

### Basic Example

```hcl
module "key_vault" {
  source = "./modules/key-vault"

  key_vault_name      = "my-keyvault"
  location            = "East US"
  resource_group_name = "my-resource-group"
  
  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
```

### Advanced Example with All Features

```hcl
module "key_vault" {
  source = "./modules/key-vault"

  # Basic Configuration
  key_vault_name              = "my-advanced-keyvault"
  location                    = "East US"
  resource_group_name         = "my-resource-group"
  sku_name                    = "premium"
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true

  # Feature Enablement
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  rbac_authorization_enabled      = false
  public_network_access_enabled   = true

  # Network Configuration
  network_acls_bypass         = "AzureServices"
  network_acls_default_action = "Deny"
  network_acls_ip_rules       = ["203.0.113.0/24", "198.51.100.42"]
  network_acls_virtual_network_subnet_ids = [
    "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx"
  ]

  # Default Access Policy
  create_default_access_policy = true
  key_permissions         = ["Get", "List", "Create", "Delete", "Update"]
  secret_permissions      = ["Get", "List", "Set", "Delete"]
  certificate_permissions = ["Get", "List", "Create", "Delete"]
  storage_permissions     = ["Get", "List"]

  # Additional Access Policies
  additional_access_policies = [
    {
      tenant_id      = "00000000-0000-0000-0000-000000000000"
      object_id      = "11111111-1111-1111-1111-111111111111"
      key_permissions    = ["Get", "List"]
      secret_permissions = ["Get", "List"]
    }
  ]

  # Certificate Contacts
  contacts = [
    {
      email = "admin@example.com"
      name  = "Key Vault Admin"
      phone = "+1-555-123-4567"
    }
  ]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

### Required Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| key_vault_name | (Required) Name of the Key Vault. Must be globally unique, 3-24 characters | `string` | n/a |
| location | (Required) Azure region where the Key Vault will be created | `string` | n/a |
| resource_group_name | (Required) Name of the resource group where the Key Vault will be created | `string` | n/a |

### Optional Variables - Basic Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| tenant_id | (Optional) Azure Active Directory tenant ID. If not specified, uses current tenant | `string` | `null` |
| sku_name | (Optional) SKU name for Key Vault. Valid values: standard, premium | `string` | `"standard"` |
| soft_delete_retention_days | (Optional) Number of days to retain deleted items. Must be 7-90 | `number` | `90` |
| purge_protection_enabled | (Optional) Enable purge protection | `bool` | `true` |
| tags | (Optional) Tags to apply to the Key Vault | `map(string)` | `{}` |

### Optional Variables - Feature Enablement

| Name | Description | Type | Default |
|------|-------------|------|---------|
| enabled_for_deployment | (Optional) Allow Azure VMs to retrieve certificates as secrets | `bool` | `false` |
| enabled_for_disk_encryption | (Optional) Allow Azure Disk Encryption to retrieve secrets and unwrap keys | `bool` | `false` |
| enabled_for_template_deployment | (Optional) Allow Azure Resource Manager to retrieve secrets | `bool` | `false` |
| rbac_authorization_enabled | (Optional) Use RBAC for authorization of data actions | `bool` | `false` |
| public_network_access_enabled | (Optional) Enable public network access | `bool` | `true` |

### Optional Variables - Network Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| network_acls_bypass | (Optional) Bypass network ACLs for services. Valid: AzureServices, None | `string` | `"AzureServices"` |
| network_acls_default_action | (Optional) Default action for network ACLs. Valid: Allow, Deny | `string` | `"Deny"` |
| network_acls_ip_rules | (Optional) List of IP addresses or CIDR blocks allowed access | `list(string)` | `[]` |
| network_acls_virtual_network_subnet_ids | (Optional) List of subnet IDs allowed access | `list(string)` | `[]` |

### Optional Variables - Access Policies

| Name | Description | Type | Default |
|------|-------------|------|---------|
| create_default_access_policy | (Optional) Create default access policy for current user/service principal | `bool` | `true` |
| key_permissions | (Optional) Key permissions for the default access policy | `list(string)` | `["Get", "List", "Create", "Delete", "Update"]` |
| secret_permissions | (Optional) Secret permissions for the default access policy | `list(string)` | `["Get", "List", "Set", "Delete"]` |
| certificate_permissions | (Optional) Certificate permissions for the default access policy | `list(string)` | `["Get", "List", "Create", "Delete"]` |
| storage_permissions | (Optional) Storage permissions for the default access policy | `list(string)` | `[]` |
| additional_access_policies | (Optional) List of additional access policies | `list(object)` | `[]` |

### Optional Variables - Contacts

| Name | Description | Type | Default |
|------|-------------|------|---------|
| contacts | (Optional) List of contact information for certificate notifications | `list(object)` | `[]` |

## Outputs

| Name | Description |
|------|-------------|
| key_vault_id | The ID of the Key Vault |
| key_vault_name | The name of the Key Vault |
| key_vault_uri | The URI of the Key Vault |
| key_vault_tenant_id | The tenant ID of the Key Vault |
| key_vault_location | The location of the Key Vault |
| key_vault_resource_group_name | The resource group name of the Key Vault |
| key_vault_sku_name | The SKU name of the Key Vault |
| key_vault_soft_delete_retention_days | The soft delete retention days |
| key_vault_purge_protection_enabled | Whether purge protection is enabled |
| key_vault_enabled_for_deployment | Whether enabled for deployment |
| key_vault_enabled_for_disk_encryption | Whether enabled for disk encryption |
| key_vault_enabled_for_template_deployment | Whether enabled for template deployment |
| key_vault_rbac_authorization_enabled | Whether RBAC authorization is enabled |
| key_vault_public_network_access_enabled | Whether public network access is enabled |

## Permission Values

### Key Permissions
Valid values: `Backup`, `Create`, `Decrypt`, `Delete`, `Encrypt`, `Get`, `GetRotationPolicy`, `Import`, `List`, `Purge`, `Recover`, `Release`, `Restore`, `Rotate`, `SetRotationPolicy`, `Sign`, `UnwrapKey`, `Update`, `Verify`, `WrapKey`

### Secret Permissions
Valid values: `Backup`, `Delete`, `Get`, `List`, `Purge`, `Recover`, `Restore`, `Set`

### Certificate Permissions
Valid values: `Backup`, `Create`, `Delete`, `DeleteIssuers`, `Get`, `GetIssuers`, `Import`, `List`, `ListIssuers`, `ManageContacts`, `ManageIssuers`, `Purge`, `Recover`, `Restore`, `SetIssuers`, `Update`

### Storage Permissions
Valid values: `Backup`, `Delete`, `DeleteSAS`, `Get`, `GetSAS`, `List`, `ListSAS`, `Purge`, `Recover`, `RegenerateKey`, `Restore`, `Set`, `SetSAS`, `Update`

## Notes

### Access Policy vs RBAC
- Set `rbac_authorization_enabled = true` to use Azure RBAC instead of access policies
- **IMPORTANT**: When RBAC is enabled, access policies are ignored by Azure Key Vault
- The module automatically prevents access policy creation when RBAC is enabled
- Recommended to set `create_default_access_policy = false` when using RBAC
- RBAC provides more granular control and integrates with Azure IAM

### Tenant ID Configuration
- The `tenant_id` variable is optional and defaults to the current tenant
- **WARNING**: When providing a custom `tenant_id`, ensure it matches the tenant of the service principal/user whose `object_id` will be used for access policies
- Mismatched tenant_id and object_id will cause access policy failures

### Network Security
- Default configuration uses `network_acls_default_action = "Deny"` for security
- Add your IP addresses or subnet IDs to `network_acls_ip_rules` or `network_acls_virtual_network_subnet_ids`
- `network_acls_bypass = "AzureServices"` allows trusted Azure services to access the vault

### Soft Delete and Purge Protection
- Soft delete is always enabled with a configurable retention period (7-90 days)
- Purge protection prevents permanent deletion during retention period
- Recommended to enable `purge_protection_enabled = true` for production

### Backward Compatibility
- All new variables have sensible defaults
- Existing configurations will continue to work without changes
- The default access policy can be disabled by setting `create_default_access_policy = false`

## Examples

See the `example/` directory for:
- `terraform.tfvars` - Basic configuration example
- `terraform-advanced.tfvars` - Advanced configuration with all features

## License

MIT

## Authors

Module managed by Terraform
