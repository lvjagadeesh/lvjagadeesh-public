# Staging Environment - Virtual Networks Configuration

# Virtual Networks
virtual_networks = {
  "main" = {
    name                = "staging-vnet"
    address_space       = ["10.1.0.0/16"]
    location            = "East US"
    resource_group_name = "staging-rg"
    subnets = [
      {
        name             = "staging-subnet-1"
        address_prefixes = ["10.1.1.0/24"]
      },
      {
        name             = "staging-subnet-2"
        address_prefixes = ["10.1.2.0/24"]
      }
    ]
    tags = {
      Purpose = "Staging network"
    }
  }
}
