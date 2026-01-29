# Production Environment - Resource Groups Configuration

# Resource Groups
resource_groups = {
  "primary" = {
    name     = "prod-rg"
    location = "East US"
    tags = {
      Purpose = "Primary production resources"
    }
  }
}
