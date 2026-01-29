# Production Environment - Virtual Networks Configuration

# Virtual Networks
virtual_networks = {
  "main" = {
    name                = "prod-vnet"
    address_space       = ["10.2.0.0/16"]
    location            = "East US"
    resource_group_name = "prod-rg"
    subnets = [
      {
        name             = "prod-subnet-1"
        address_prefixes = ["10.2.1.0/24"]
      },
      {
        name             = "prod-subnet-2"
        address_prefixes = ["10.2.2.0/24"]
      },
      {
        name             = "prod-subnet-3"
        address_prefixes = ["10.2.3.0/24"]
      }
    ]
    tags = {
      Purpose = "Production network"
    }
  }
}
