#================================================
# Terraform Configuration for Development Environment
# Project: kai123 - Azure Infrastructure as Code
# Environment: Development
# Purpose: Creates VM, App Service, and supporting infrastructure
# Naming Convention: Microsoft Azure Cloud Adoption Framework
#================================================

# Configure Terraform and Required Providers
terraform {
  required_providers {
    # Azure Resource Manager Provider for managing Azure resources
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"  # Use latest 3.x version for stability
    }
    # Random Provider for generating secure passwords
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
  required_version = ">= 1.0"  # Minimum Terraform version required
}

# Configure the Azure Provider with default features
provider "azurerm" {
  features {}  # Use default feature set
}

#================================================
# Local Values and Tags
#================================================

# Common tags applied to all resources for governance and cost tracking
locals {
  common_tags = {
    Environment = var.environment    # Environment identifier (dev/uat/production)
    Project     = var.project_name   # Project name for resource grouping
  }
}

#================================================
# Resource Group
# Purpose: Container for all project resources in this environment
# Naming: rg-kai123-dev-001 (follows Microsoft naming convention)
#================================================

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name  # rg-kai123-dev-001
  location = var.location             # Southeast Asia

  tags = local.common_tags
}

#================================================
# Network Module
# Purpose: Creates VNet, subnets, and network security groups
# Components:
# - Virtual Network (vnet-kai123-sea-001)
# - VM Subnet (snet-kai123-vm-sea-001) - 10.1.1.0/24
# - App Service Subnet (snet-kai123-app-sea-001) - 10.1.2.0/24
# - Private Endpoint Subnet (snet-kai123-pe-sea-001) - 10.1.3.0/24
# - Network Security Group with SSH, HTTP, HTTPS rules
#================================================

module "network" {
  source = "../../modules/network"

  # Resource naming parameters
  prefix                              = var.prefix                              # kai123-dev
  project_name                        = var.project_name                       # kai123
  
  # Location and resource group
  location                            = azurerm_resource_group.main.location
  resource_group_name                 = azurerm_resource_group.main.name
  
  # Network configuration - Development environment uses 10.1.0.0/16
  vnet_address_space                  = var.vnet_address_space                 # 10.1.0.0/16
  subnet_address_prefix               = var.subnet_address_prefix              # 10.1.1.0/24
  app_service_subnet_address_prefix   = var.app_service_subnet_address_prefix  # 10.1.2.0/24
  private_endpoint_subnet_address_prefix = var.private_endpoint_subnet_address_prefix # 10.1.3.0/24
  
  # Security configuration
  allowed_ssh_ip                      = var.allowed_ssh_ip                     # "*" for dev (restrict in production)

  tags = local.common_tags
}

#================================================
# Compute Module
# Purpose: Creates Ubuntu VM with Spot pricing for cost optimization
# Components:
# - Linux Virtual Machine (vm-kai123-dev-001) with Ubuntu 22.04 LTS
# - Network Interface (nic-01-vmkai123-dev-001)
# - Public IP (pip-kai123-dev-sea-001)
# - Spot Instance pricing for development cost savings
# Dependencies: Network module (subnet and NSG)
#================================================

module "compute" {
  source = "../../modules/compute"

  # Resource naming parameters
  prefix               = var.prefix               # kai123-dev
  project_name         = var.project_name         # kai123
  environment          = var.environment          # dev
  
  # Location and resource group
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  
  # Network dependencies from network module
  subnet_id            = module.network.subnet_id  # VM subnet
  nsg_id               = module.network.nsg_id     # Network security group
  
  # VM configuration optimized for development
  vm_size              = var.vm_size               # Standard_B2as_v2 (2 vCPU, 4GB RAM)
  admin_username       = var.admin_username        # azureuser
  storage_account_type = var.storage_account_type  # Standard_LRS (cost-effective for dev)

  tags = local.common_tags
}

#================================================
# Storage Module
# Purpose: Creates storage account for VM boot diagnostics
# Component: Storage Account (stkai123dev001)
# Configuration: Standard LRS for cost optimization in development
#================================================

module "storage" {
  source = "../../modules/storage"

  # Resource naming parameters
  prefix              = var.prefix              # kai123-dev
  project_name        = var.project_name        # kai123
  environment         = var.environment         # dev
  
  # Location and resource group
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.common_tags
}

#================================================
# App Service Module
# Purpose: Creates secure App Service with private connectivity
# Components:
# - App Service Plan (plan-kai123-dev-001) - Basic B1 tier
# - Linux Web App (app-kai123-dev-001) with Node.js 18 LTS
# - VNet Integration for outbound connectivity
# - Private Endpoint (pe-app-kai123-dev-001) for inbound access
# - Private DNS Zone (privatelink.azurewebsites.net)
# Security: Public access disabled, accessible only via private endpoint
# Dependencies: Network module (app service subnet and private endpoint subnet)
#================================================

module "app_service" {
  source = "../../modules/app-service"

  # Resource naming parameters
  prefix                      = var.prefix                      # kai123-dev
  project_name                = var.project_name                # kai123
  environment                 = var.environment                 # dev
  
  # Location and resource group
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  
  # Network dependencies from network module
  vnet_id                     = module.network.vnet_id                     # Virtual network
  app_service_subnet_id       = module.network.app_service_subnet_id       # App Service integration subnet
  private_endpoint_subnet_id  = module.network.private_endpoint_subnet_id  # Private endpoint subnet

  tags = local.common_tags
} 