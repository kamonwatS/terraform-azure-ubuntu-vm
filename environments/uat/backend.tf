# Backend configuration for UAT environment
# This file configures where Terraform state is stored

terraform {
  # Uncomment and configure for remote state storage
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "terraformstateuat"
  #   container_name      = "tfstate"
  #   key                 = "uat/terraform.tfstate"
  # }
  
  # For now, using local state (default)
  # To enable remote state:
  # 1. Create a storage account for Terraform state
  # 2. Uncomment the backend block above
  # 3. Run: terraform init -migrate-state
} 