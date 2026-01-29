resource_groups = {
  "rg1" = {
    name     = "example-rg-01"
    location = "East US"
    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
    }
  }
  "rg2" = {
    name     = "example-rg-02"
    location = "West US"
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  }
  "rg3" = {
    name       = "example-rg-managed"
    location   = "Central US"
    managed_by = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/management-rg"
    tags = {
      Environment = "Shared"
      ManagedBy   = "Terraform"
    }
  }
}
