virtual_networks = {
  primary = {
    name                = "example-vnet-primary"
    address_space       = ["10.0.0.0/16"]
    location            = "East US"
    resource_group_name = "example-rg"
    subnets = [
      {
        name             = "subnet1"
        address_prefixes = ["10.0.1.0/24"]
      },
      {
        name              = "subnet2"
        address_prefixes  = ["10.0.2.0/24"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      }
    ]
    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
      Purpose     = "Primary"
    }
  }

  secondary = {
    name                = "example-vnet-secondary"
    address_space       = ["10.1.0.0/16"]
    location            = "West US"
    resource_group_name = "example-rg-west"
    dns_servers         = ["10.1.0.4", "10.1.0.5"]
    subnets = [
      {
        name             = "app-subnet"
        address_prefixes = ["10.1.1.0/24"]
      },
      {
        name                              = "db-subnet"
        address_prefixes                  = ["10.1.2.0/24"]
        private_endpoint_network_policies = "Enabled"
      }
    ]
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      Purpose     = "Secondary"
    }
  }
}
