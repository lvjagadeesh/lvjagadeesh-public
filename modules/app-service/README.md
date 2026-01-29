# Azure Linux Web App Terraform Module

A comprehensive, production-ready Terraform module for deploying Azure Linux Web Apps with full support for all `azurerm_linux_web_app` resource arguments from AzureRM provider v4.x.

## Features

This module provides complete configuration options for:

- ✅ **Core Features**: Network access, client certificates, HTTPS enforcement, VNet integration
- ✅ **Site Configuration**: 25+ site_config attributes including always_on, health checks, TLS settings
- ✅ **Application Stacks**: Docker, .NET, Go, Java, Node.js, PHP, Python, Ruby
- ✅ **Auto-Healing**: Advanced auto-heal configuration with custom triggers
- ✅ **Security**: IP restrictions, CORS, authentication (v1 & v2), managed identities
- ✅ **Logging**: Application logs, HTTP logs with Azure Blob Storage or File System
- ✅ **Storage**: Azure Storage account mounting (Blob & Files)
- ✅ **Backup**: Automated backup configuration with scheduling
- ✅ **Deployment**: ZIP deploy, WebDeploy, FTP with authentication controls

## Usage

### Basic Docker Deployment

```hcl
module "app_service" {
  source = "./modules/app-service"

  app_service_name    = "my-app-service"
  location            = "eastus"
  resource_group_name = "my-rg"
  service_plan_id     = azurerm_service_plan.example.id

  docker_image_name   = "nginx:latest"
  docker_registry_url = "https://index.docker.io"

  app_settings = {
    "ENVIRONMENT" = "production"
    "LOG_LEVEL"   = "info"
  }

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

### Advanced Configuration with Node.js

```hcl
module "app_service" {
  source = "./modules/app-service"

  app_service_name    = "my-nodejs-app"
  location            = "eastus"
  resource_group_name = "my-rg"
  service_plan_id     = azurerm_service_plan.example.id

  # Application stack
  node_version = "18-lts"

  # Security
  https_only                     = true
  public_network_access_enabled  = true
  client_certificate_enabled     = false
  minimum_tls_version           = "1.2"

  # Site configuration
  always_on       = true
  http2_enabled   = true
  ftps_state      = "Disabled"
  websockets_enabled = true

  # Health check
  health_check_path                = "/health"
  health_check_eviction_time_in_min = 5

  # VNet integration
  virtual_network_subnet_id = azurerm_subnet.app.id
  vnet_route_all_enabled   = true

  # Identity
  identity_type = "SystemAssigned"

  # Application settings
  app_settings = {
    "NODE_ENV"     = "production"
    "PORT"         = "8080"
    "API_BASE_URL" = "https://api.example.com"
  }

  tags = {
    Environment = "Production"
    Application = "WebApp"
  }
}
```

### With IP Restrictions

```hcl
module "app_service" {
  source = "./modules/app-service"

  app_service_name    = "my-secure-app"
  location            = "eastus"
  resource_group_name = "my-rg"
  service_plan_id     = azurerm_service_plan.example.id

  python_version = "3.11"

  ip_restriction = [
    {
      name       = "AllowOfficeIP"
      ip_address = "203.0.113.0/24"
      priority   = 100
      action     = "Allow"
    },
    {
      name                      = "AllowVNet"
      virtual_network_subnet_id = azurerm_subnet.trusted.id
      priority                  = 200
      action                    = "Allow"
    }
  ]

  ip_restriction_default_action = "Deny"
}
```

### With Auto-Heal Configuration

```hcl
module "app_service" {
  source = "./modules/app-service"

  app_service_name    = "my-resilient-app"
  location            = "eastus"
  resource_group_name = "my-rg"
  service_plan_id     = azurerm_service_plan.example.id

  dotnet_version = "8.0"

  auto_heal_setting = {
    action = {
      action_type                    = "Recycle"
      minimum_process_execution_time = "00:01:00"
    }
    trigger = {
      requests = {
        count    = 100
        interval = "00:00:30"
      }
      slow_request = {
        count      = 5
        interval   = "00:01:00"
        time_taken = "00:00:30"
      }
      status_code = [
        {
          count             = 10
          interval          = "00:01:00"
          status_code_range = "500-599"
        }
      ]
    }
  }
}
```

### With Azure Storage Mount

```hcl
module "app_service" {
  source = "./modules/app-service"

  app_service_name    = "my-storage-app"
  location            = "eastus"
  resource_group_name = "my-rg"
  service_plan_id     = azurerm_service_plan.example.id

  php_version = "8.2"

  storage_accounts = [
    {
      name         = "uploads"
      type         = "AzureFiles"
      account_name = azurerm_storage_account.example.name
      share_name   = azurerm_storage_share.uploads.name
      access_key   = azurerm_storage_account.example.primary_access_key
      mount_path   = "/mnt/uploads"
    }
  ]
}
```

### With Backup Configuration

```hcl
module "app_service" {
  source = "./modules/app-service"

  app_service_name    = "my-backed-up-app"
  location            = "eastus"
  resource_group_name = "my-rg"
  service_plan_id     = azurerm_service_plan.example.id

  java_server         = "JAVA"
  java_server_version = "17"
  java_version        = "17"

  backup = {
    name                = "daily-backup"
    storage_account_url = "https://mystorageaccount.blob.core.windows.net/backups?${data.azurerm_storage_account_sas.backup.sas}"
    enabled             = true
    schedule = {
      frequency_interval       = 1
      frequency_unit           = "Day"
      keep_at_least_one_backup = true
      retention_period_days    = 30
      start_time               = "2024-01-01T02:00:00Z"
    }
  }
}
```

### With Authentication (Azure AD)

```hcl
module "app_service" {
  source = "./modules/app-service"

  app_service_name    = "my-authenticated-app"
  location            = "eastus"
  resource_group_name = "my-rg"
  service_plan_id     = azurerm_service_plan.example.id

  go_version = "1.21"

  auth_settings = {
    enabled          = true
    default_provider = "AzureActiveDirectory"
    active_directory = {
      client_id = "00000000-0000-0000-0000-000000000000"
      client_secret_setting_name = "AAD_CLIENT_SECRET"
    }
    unauthenticated_client_action = "RedirectToLoginPage"
  }

  app_settings = {
    "AAD_CLIENT_SECRET" = "@Microsoft.KeyVault(SecretUri=https://myvault.vault.azure.net/secrets/aad-secret/)"
  }
}
```

### With Logging

```hcl
module "app_service" {
  source = "./modules/app-service"

  app_service_name    = "my-logged-app"
  location            = "eastus"
  resource_group_name = "my-rg"
  service_plan_id     = azurerm_service_plan.example.id

  ruby_version = "2.7"

  logs = {
    detailed_error_messages = true
    failed_request_tracing  = true
    
    application_logs = {
      file_system_level = "Information"
      azure_blob_storage = {
        level             = "Error"
        retention_in_days = 90
        sas_url           = "https://mystorageaccount.blob.core.windows.net/logs?${data.azurerm_storage_account_sas.logs.sas}"
      }
    }

    http_logs = {
      file_system = {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }
}
```

### With User-Assigned Managed Identity

```hcl
module "app_service" {
  source = "./modules/app-service"

  app_service_name    = "my-identity-app"
  location            = "eastus"
  resource_group_name = "my-rg"
  service_plan_id     = azurerm_service_plan.example.id

  docker_image_name = "myregistry.azurecr.io/myapp:latest"
  docker_registry_url = "https://myregistry.azurecr.io"
  
  container_registry_use_managed_identity           = true
  container_registry_managed_identity_client_id     = azurerm_user_assigned_identity.acr.client_id

  identity_type = "SystemAssigned, UserAssigned"
  identity_ids  = [azurerm_user_assigned_identity.acr.id]

  key_vault_reference_identity_id = azurerm_user_assigned_identity.acr.id
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

## Resources

| Name | Type |
|------|------|
| azurerm_linux_web_app.this | resource |

## Inputs

### Required Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| app_service_name | Name of the App Service. Must be globally unique | `string` | n/a |
| location | Azure region where the App Service will be created | `string` | n/a |
| resource_group_name | Name of the resource group | `string` | n/a |
| service_plan_id | ID of the App Service Plan | `string` | n/a |

### Core Optional Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| enabled | Should the Linux Web App be enabled? | `bool` | `true` |
| app_settings | Application settings as key-value pairs | `map(string)` | `{}` |
| tags | Tags to apply to the App Service | `map(string)` | `{}` |
| public_network_access_enabled | Should public network access be enabled? | `bool` | `true` |
| client_affinity_enabled | Should Client Affinity be enabled? | `bool` | `false` |
| client_certificate_enabled | Should Client Certificates be enabled? | `bool` | `false` |
| client_certificate_mode | The Client Certificate mode | `string` | `"Required"` |
| client_certificate_exclusion_paths | Paths to exclude when using client certificates | `string` | `null` |
| https_only | Should the Web App require HTTPS connections? | `bool` | `true` |
| virtual_network_subnet_id | The subnet ID for VNet integration | `string` | `null` |
| key_vault_reference_identity_id | The identity ID to use for Key Vault references | `string` | `null` |
| zip_deploy_file | The local path to the ZIP file to deploy | `string` | `null` |
| webdeploy_publish_basic_authentication_enabled | Should basic auth be enabled for WebDeploy? | `bool` | `true` |
| ftp_publish_basic_authentication_enabled | Should basic auth be enabled for FTP? | `bool` | `true` |

### Site Config Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| always_on | Should the app be loaded at all times? | `bool` | `true` |
| api_definition_url | URL of the OpenAPI definition | `string` | `null` |
| api_management_api_id | ID of the API Management API | `string` | `null` |
| app_command_line | The command to launch the app | `string` | `null` |
| auto_heal_setting | Auto-heal configuration block | `object` | `null` |
| container_registry_use_managed_identity | Should Managed Identity be used for container registry? | `bool` | `false` |
| container_registry_managed_identity_client_id | Client ID of Managed Identity for container registry | `string` | `null` |
| default_documents | List of default documents | `list(string)` | `null` |
| ftps_state | State of FTP/FTPS service | `string` | `"Disabled"` |
| health_check_path | Path to check for health | `string` | `null` |
| health_check_eviction_time_in_min | Time in minutes after which instance is evicted if unhealthy | `number` | `null` |
| http2_enabled | Should HTTP2 be enabled? | `bool` | `false` |
| ip_restriction | List of IP restriction rules | `list(object)` | `[]` |
| ip_restriction_default_action | Default action for IP restrictions | `string` | `"Allow"` |
| load_balancing_mode | The load balancing mode | `string` | `"LeastRequests"` |
| local_mysql_enabled | Should local MySQL be enabled? | `bool` | `false` |
| managed_pipeline_mode | The managed pipeline mode | `string` | `"Integrated"` |
| minimum_tls_version | The minimum TLS version | `string` | `"1.2"` |
| remote_debugging_enabled | Should remote debugging be enabled? | `bool` | `false` |
| remote_debugging_version | The remote debugging version | `string` | `null` |
| scm_ip_restriction | List of IP restriction rules for SCM site | `list(object)` | `[]` |
| scm_ip_restriction_default_action | Default action for SCM IP restrictions | `string` | `"Allow"` |
| scm_minimum_tls_version | The minimum TLS version for SCM | `string` | `"1.2"` |
| scm_use_main_ip_restriction | Should SCM site use same IP restrictions as main? | `bool` | `false` |
| use_32_bit_worker | Should 32-bit worker process be used? | `bool` | `false` |
| vnet_route_all_enabled | Should all outbound traffic be routed through VNet? | `bool` | `false` |
| websockets_enabled | Should WebSockets be enabled? | `bool` | `false` |
| worker_count | Number of workers | `number` | `null` |

### Application Stack Inputs

| Name | Description | Type | Default | Possible Values |
|------|-------------|------|---------|-----------------|
| docker_image_name | Docker image name | `string` | `null` | e.g., `nginx:latest` |
| docker_registry_url | Docker registry URL | `string` | `"https://index.docker.io"` | Any registry URL |
| docker_registry_username | Username for docker registry | `string` | `null` | - |
| docker_registry_password | Password for docker registry | `string` | `null` | - |
| dotnet_version | Version of .NET | `string` | `null` | `3.1`, `5.0`, `6.0`, `7.0`, `8.0` |
| go_version | Version of Go | `string` | `null` | `1.18`, `1.19`, `1.20`, `1.21` |
| java_server | Java server type | `string` | `null` | `JAVA`, `TOMCAT`, `JBOSSEAP` |
| java_server_version | Java server version | `string` | `null` | Server-dependent |
| java_version | Version of Java | `string` | `null` | `8`, `11`, `17`, `21` |
| node_version | Version of Node.js | `string` | `null` | `12-lts`, `14-lts`, `16-lts`, `18-lts`, `20-lts` |
| php_version | Version of PHP | `string` | `null` | `7.4`, `8.0`, `8.1`, `8.2` |
| python_version | Version of Python | `string` | `null` | `3.7`, `3.8`, `3.9`, `3.10`, `3.11` |
| ruby_version | Version of Ruby | `string` | `null` | `2.6`, `2.7` |

### Additional Configuration Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| cors_allowed_origins | List of allowed origins for CORS | `list(string)` | `[]` |
| cors_support_credentials | Should credentials be supported in CORS? | `bool` | `false` |
| auth_settings | Authentication settings (v1) | `object` | `null` |
| auth_settings_v2 | Authentication settings (v2) | `object` | `null` |
| backup | Backup configuration | `object` | `null` |
| connection_strings | Connection strings | `list(object)` | `[]` |
| storage_accounts | Storage account mounts | `list(object)` | `[]` |
| logs | Logging configuration | `object` | `null` |
| identity_type | Type of Managed Identity | `string` | `"SystemAssigned"` |
| identity_ids | List of User Assigned Identity IDs | `list(string)` | `[]` |
| sticky_settings | Sticky settings configuration | `object` | `null` |

See [variables.tf](./variables.tf) for complete input specifications with validation rules.

## Outputs

| Name | Description |
|------|-------------|
| app_service_id | The ID of the App Service |
| app_service_name | The name of the App Service |
| app_service_url | The HTTPS URL of the App Service |
| default_hostname | The default hostname |
| custom_domain_verification_id | Domain verification ID |
| identity_principal_id | Principal ID of system-assigned identity |
| identity_tenant_id | Tenant ID of system-assigned identity |
| identity | Full identity block |
| outbound_ip_addresses | Outbound IP addresses (comma-separated) |
| outbound_ip_address_list | Outbound IP addresses (list) |
| possible_outbound_ip_addresses | Possible outbound IPs (comma-separated) |
| possible_outbound_ip_address_list | Possible outbound IPs (list) |
| site_credential | Site credentials for publishing |
| scm_url | SCM (Kudu) URL |

See [outputs.tf](./outputs.tf) for complete output specifications.

## Important Notes

### Application Stack Selection

Only **ONE** application stack should be configured at a time:
- Docker: `docker_image_name`
- .NET: `dotnet_version`
- Go: `go_version`
- Java: `java_version` + `java_server` + `java_server_version`
- Node.js: `node_version`
- PHP: `php_version`
- Python: `python_version`
- Ruby: `ruby_version`

### Backward Compatibility

This module maintains backward compatibility with previous versions. All new variables are optional with sensible defaults.

### Identity Configuration

- `SystemAssigned`: Automatically creates a managed identity
- `UserAssigned`: Requires `identity_ids` to be specified
- `SystemAssigned, UserAssigned`: Enables both types, requires `identity_ids`

### Security Best Practices

1. Always set `https_only = true` in production
2. Use `minimum_tls_version = "1.2"` or higher
3. Set `ftps_state = "Disabled"` or `"FtpsOnly"`
4. Configure IP restrictions for sensitive applications
5. Enable client certificates when required
6. Use managed identities instead of connection strings
7. Store secrets in Azure Key Vault and reference them via `app_settings`

### Validation Rules

The module includes comprehensive validation for:
- TLS versions (1.0, 1.1, 1.2, 1.3)
- FTPS states (AllAllowed, FtpsOnly, Disabled)
- Client certificate modes (Required, Optional, OptionalInteractiveUser)
- Application stack versions
- Load balancing modes
- IP restriction actions (Allow, Deny)
- Connection string types
- Storage account types
- Log levels
- And many more...

## Examples

See the [example](./example) directory for complete working examples.

## License

See repository license.

## Contributing

Contributions are welcome! Please submit issues and pull requests to the repository.

## Authors

Maintained by the platform team.
