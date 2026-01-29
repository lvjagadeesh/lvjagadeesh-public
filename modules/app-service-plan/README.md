# Azure App Service Plan Terraform Module

This Terraform module creates and manages an Azure App Service Plan (Service Plan) with comprehensive support for all available configuration options.

## Features

- ✅ **Complete AzureRM Provider Support**: Implements ALL arguments from `azurerm_service_plan` resource (AzureRM v4.x)
- ✅ **Production-Ready**: Includes validation rules, proper defaults, and comprehensive outputs
- ✅ **Backward Compatible**: All new variables are optional with sensible defaults
- ✅ **Flexible Configuration**: Supports all OS types, SKUs, and scaling options
- ✅ **Customizable Timeouts**: Configure create, read, update, and delete operation timeouts

## Supported Features

### Core Features
- All OS types: Linux, Windows, WindowsContainer
- All SKU types: Basic, Free, Standard, Premium, Elastic, Isolated
- App Service Environment integration
- Per-site scaling
- Zone balancing across Availability Zones
- Elastic worker scaling
- Custom worker count configuration
- Custom timeout settings

## Usage

### Basic Example

```hcl
module "app_service_plan" {
  source = "./modules/app-service-plan"

  app_service_plan_name = "my-app-service-plan"
  location              = "East US"
  resource_group_name   = "my-resource-group"
  os_type               = "Linux"
  sku_name              = "P1v3"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

### Advanced Example with All Features

```hcl
module "app_service_plan" {
  source = "./modules/app-service-plan"

  app_service_plan_name = "my-advanced-app-service-plan"
  location              = "East US"
  resource_group_name   = "my-resource-group"
  os_type               = "Linux"
  sku_name              = "P1v3"

  # Optional: App Service Environment (for Isolated SKUs)
  # app_service_environment_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Web/hostingEnvironments/example-ase"

  # Optional: Scaling configuration
  worker_count                 = 3
  maximum_elastic_worker_count = 20
  per_site_scaling_enabled     = true
  zone_balancing_enabled       = true

  # Optional: Custom timeouts
  timeouts = {
    create = "90m"
    read   = "10m"
    update = "90m"
    delete = "90m"
  }

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    CostCenter  = "Engineering"
  }
}
```

### Isolated SKU with App Service Environment

```hcl
module "isolated_app_service_plan" {
  source = "./modules/app-service-plan"

  app_service_plan_name      = "isolated-asp"
  location                   = "East US"
  resource_group_name        = "my-resource-group"
  os_type                    = "Linux"
  sku_name                   = "I1v2"
  app_service_environment_id = azurerm_app_service_environment_v3.example.id

  tags = {
    Environment = "Production"
    Isolation   = "Enabled"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app_service_plan_name | (Required) Name of the App Service Plan. Must be unique within the resource group. Changing this forces a new resource to be created. | `string` | n/a | yes |
| location | (Required) Azure region where the App Service Plan will be created | `string` | n/a | yes |
| resource_group_name | (Required) Name of the resource group where the App Service Plan will be created | `string` | n/a | yes |
| os_type | (Required) OS type for App Services to be hosted in the App Service Plan. Valid values: Linux, Windows, WindowsContainer | `string` | `"Linux"` | no |
| sku_name | (Required) SKU name for the App Service Plan. See SKU Options section below | `string` | `"P1v2"` | no |
| app_service_environment_id | (Optional) The ID of the App Service Environment to create this Service Plan in. Required if using Isolated SKUs | `string` | `null` | no |
| maximum_elastic_worker_count | (Optional) The maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU | `number` | `null` | no |
| worker_count | (Optional) The number of Workers (instances) to be allocated. Must be between 1 and 30 | `number` | `null` | no |
| per_site_scaling_enabled | (Optional) Should Per Site Scaling be enabled. Allows apps to scale independently within the plan | `bool` | `false` | no |
| zone_balancing_enabled | (Optional) Should the Service Plan balance across Availability Zones in the region. Changing this forces a new resource to be created | `bool` | `false` | no |
| tags | (Optional) A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| timeouts | (Optional) Customizable timeout settings for create, read, update, and delete operations | `object` | See below | no |

### Timeouts Default

```hcl
{
  create = "60m"
  read   = "5m"
  update = "60m"
  delete = "60m"
}
```

## Outputs

| Name | Description |
|------|-------------|
| app_service_plan_id | The ID of the App Service Plan |
| app_service_plan_name | The name of the App Service Plan |
| location | The Azure region where the App Service Plan is located |
| resource_group_name | The name of the resource group containing the App Service Plan |
| os_type | The OS type for the App Service Plan |
| sku_name | The SKU name of the App Service Plan |
| kind | The kind of the App Service Plan |
| reserved | Whether this is a reserved Service Plan Type (true if os_type is Linux) |
| app_service_environment_id | The ID of the App Service Environment used by the Service Plan (if applicable) |
| maximum_elastic_worker_count | The maximum number of workers for an Elastic SKU Service Plan |
| worker_count | The number of workers allocated to the App Service Plan |
| per_site_scaling_enabled | Whether per site scaling is enabled |
| zone_balancing_enabled | Whether zone balancing is enabled for the Service Plan |
| tags | The tags assigned to the App Service Plan |

## SKU Options

### Basic SKUs
- `B1`, `B2`, `B3` - Basic tier for dev/test workloads

### Standard SKUs
- `S1`, `S2`, `S3` - Standard tier with auto-scaling and custom domains

### Premium V2 SKUs
- `P1v2`, `P2v2`, `P3v2` - Enhanced performance with more CPU and memory

### Premium V3 SKUs
- `P0v3`, `P1v3`, `P2v3`, `P3v3` - Latest generation with improved performance
- `P1mv3`, `P2mv3`, `P3mv3`, `P4mv3`, `P5mv3` - Memory-optimized variants

### Premium V4 SKUs (Latest)
- `P0v4`, `P1v4`, `P2v4`, `P3v4` - Latest generation
- `P1mv4`, `P2mv4`, `P3mv4`, `P4mv4`, `P5mv4` - Memory-optimized variants

### Isolated SKUs
- `I1`, `I2`, `I3` - Gen1 isolated environment (requires App Service Environment)
- `I1v2`, `I2v2`, `I3v2`, `I4v2`, `I5v2`, `I6v2` - Gen2 isolated environment

### Elastic Premium SKUs
- `EP1`, `EP2`, `EP3` - Elastic scaling for Azure Functions

### Consumption SKUs
- `Y1` - Consumption plan for Azure Functions
- `FC1` - FlexConsumption plan

### Other SKUs
- `F1` - Free tier
- `D1` - Shared tier
- `SHARED` - Shared hosting
- `WS1`, `WS2`, `WS3` - Windows Container dedicated

## Validation Rules

The module includes comprehensive validation:

1. **App Service Plan Name**: Must be 1-60 characters
2. **Location**: Must be specified
3. **Resource Group Name**: Must be specified
4. **OS Type**: Must be one of: Linux, Windows, WindowsContainer
5. **SKU Name**: Must be specified
6. **Worker Count**: Must be between 1 and 30 (if specified)
7. **Maximum Elastic Worker Count**: Must be a positive number (if specified)

## Important Notes

### Zone Balancing
- Setting `zone_balancing_enabled = true` will force creation of a new resource if changed later
- Zone balancing requires Azure regions with Availability Zone support

### App Service Environment
- `app_service_environment_id` is required when using Isolated SKUs (I-series)
- App Service Environments provide isolated and dedicated hosting environment

### Worker Count vs Elastic Workers
- `worker_count`: Sets the base number of instances
- `maximum_elastic_worker_count`: Only for Elastic SKUs (EP-series), sets maximum auto-scale limit

### Per-Site Scaling
- When enabled, individual apps in the plan can scale independently
- Useful for multi-tenant scenarios

## Examples

See the `example/terraform.tfvars` file for a comprehensive example with all options documented.

## Backward Compatibility

All new variables added in this enhanced version are optional and have sensible defaults. Existing configurations will continue to work without any modifications.

## License

This module is provided as-is for use in Terraform configurations.

## References

- [Terraform AzureRM Provider - azurerm_service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan)
- [Azure App Service Plan Pricing](https://azure.microsoft.com/en-us/pricing/details/app-service/windows/)
- [Azure App Service Plan Overview](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans)
