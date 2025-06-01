# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
  required_version = ">= 1.0"
}

# Configure the Azure Provider features
provider "azurerm" {
  features {}
}

# Local values for common tags
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = local.common_tags
}

# Network Module
module "network" {
  source = "./modules/network"

  prefix                = var.prefix
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  vnet_address_space    = var.vnet_address_space
  subnet_address_prefix = var.subnet_address_prefix
  allowed_ssh_ip        = var.allowed_ssh_ip

  tags = local.common_tags
}

# Compute Module
module "compute" {
  source = "./modules/compute"

  prefix               = var.prefix
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  subnet_id            = module.network.subnet_id
  nsg_id               = module.network.nsg_id
  vm_size              = var.vm_size
  admin_username       = var.admin_username
  storage_account_type = var.storage_account_type

  tags = local.common_tags
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  prefix              = var.prefix
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.common_tags
} 