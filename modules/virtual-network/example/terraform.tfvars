vnet_name           = "example-vnet"
address_space       = ["10.0.0.0/16"]
location            = "East US"
resource_group_name = "example-rg"
subnets = [
  {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  },
  {
    name             = "subnet2"
    address_prefixes = ["10.0.2.0/24"]
  }
]
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}
