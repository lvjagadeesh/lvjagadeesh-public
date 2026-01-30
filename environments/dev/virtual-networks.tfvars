# Development Environment - Virtual Networks Configuration

# Virtual Networks
virtual_networks = {
  "main" = {
    name                = "dev-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "East US"
    resource_group_name = "dev-rg"
    subnets = [
      {
        name             = "dev-subnet-1"
        address_prefixes = ["10.0.1.0/24"]
      },
      {
        name             = "dev-subnet-2"
        address_prefixes = ["10.0.2.0/24"]
      }
    ]
    tags = {
      Purpose = "Development network"
    }
  }
}
