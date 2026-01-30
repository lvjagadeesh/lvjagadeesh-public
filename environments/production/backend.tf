# Backend configuration for Production environment
# This file configures remote state storage in Azure Storage Account

terraform {
  backend "azurerm" {
    # Replace these values with your actual Azure Storage Account details
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstateprodstg"  # Must be globally unique
    container_name       = "tfstate-prod"
    key                  = "prod.terraform.tfstate"
    
    # Optional: Enable state locking
    use_msi              = false  # Set to true if using Managed Identity
    subscription_id      = "REPLACE_WITH_YOUR_SUBSCRIPTION_ID"
    tenant_id            = "REPLACE_WITH_YOUR_TENANT_ID"
  }
}
