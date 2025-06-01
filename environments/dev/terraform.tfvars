#================================================
# Development Environment Configuration
# Project: kai123 - Azure Infrastructure as Code
# Environment: Development
# Purpose: Configuration values for development workloads
# Reference: Microsoft Azure Cloud Adoption Framework
# URL: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
#================================================

#--------------------------------------------
# Environment Identification
# Purpose: Defines environment-specific settings and resource naming
#--------------------------------------------
environment         = "dev"                    # Environment identifier for resource naming and tagging
project_name        = "kai123"                 # Project name following Azure naming convention
prefix              = "kai123-dev"             # Combined prefix for backward compatibility
location            = "Southeast Asia"         # Azure region for resource deployment
resource_group_name = "rg-kai123-dev-001"      # Resource group following naming convention: rg-<project>-<env>-<###>

#--------------------------------------------
# Network Configuration
# Architecture: Segmented subnets for different workload types
# Security: Network isolation and controlled access
#--------------------------------------------
vnet_address_space                      = "10.1.0.0/16"    # Development VNet CIDR (65,536 IPs)
subnet_address_prefix                   = "10.1.1.0/24"    # VM subnet (254 usable IPs)
app_service_subnet_address_prefix       = "10.1.2.0/24"    # App Service VNet integration subnet (254 IPs)
private_endpoint_subnet_address_prefix  = "10.1.3.0/24"    # Private endpoint subnet (254 IPs)
allowed_ssh_ip                          = "*"              # SSH access (use specific IP in production)

#--------------------------------------------
# Virtual Machine Configuration
# Optimization: Cost-effective settings for development workloads
# Security: Standard security baseline with room for experimentation
#--------------------------------------------
vm_size              = "Standard_B2as_v2"      # 2 vCPU, 4GB RAM - Burstable performance for dev
storage_account_type = "Standard_LRS"          # Standard Local Redundant Storage - cost-effective for dev
admin_username       = "azureuser"             # VM administrator username 