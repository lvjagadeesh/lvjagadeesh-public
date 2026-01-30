# Development Environment - Resource Groups Configuration

# Resource Groups
resource_groups = {
  "primary" = {
    name     = "dev-rg"
    location = "East US"
    tags = {
      Purpose = "Primary development resources"
    }
  }
}
