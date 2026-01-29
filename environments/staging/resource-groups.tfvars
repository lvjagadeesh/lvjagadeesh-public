# Staging Environment - Resource Groups Configuration

# Resource Groups
resource_groups = {
  "primary" = {
    name     = "staging-rg"
    location = "East US"
    tags = {
      Purpose = "Primary staging resources"
    }
  }
}
