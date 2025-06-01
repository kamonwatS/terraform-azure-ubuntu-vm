# Backend configuration for production environment
# This file configures where Terraform state is stored

terraform {
  # Uncomment and configure for remote state storage
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "terraformstateprod"
  #   container_name      = "tfstate"
  #   key                 = "production/terraform.tfstate"
  # }
  
  # For now, using local state (default)
  # To enable remote state:
  # 1. Create a storage account for Terraform state
  # 2. Uncomment the backend block above
  # 3. Run: terraform init -migrate-state
} 