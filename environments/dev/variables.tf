#================================================
# Development Environment Variables
# Purpose: Defines input variables for development infrastructure
# Usage: Override defaults with terraform.tfvars values
# Scope: Development environment specific configurations
#================================================

#--------------------------------------------
# Environment and Project Identification
#--------------------------------------------

variable "environment" {
  description = "Environment name (dev, uat, production) - used for resource naming and tagging"
  type        = string
  # No default - must be provided via terraform.tfvars
}

variable "project_name" {
  description = "Name of the project for Azure naming convention compliance"
  type        = string
  default     = "ubuntu-vm"    # Legacy default - override with kai123 in terraform.tfvars
}

#--------------------------------------------
# Azure Resource Configuration
#--------------------------------------------

variable "location" {
  description = "Azure region for resource deployment (e.g., Southeast Asia, East US)"
  type        = string
  default     = "Southeast Asia"    # Default region for cost optimization
}

variable "resource_group_name" {
  description = "Name of the Azure resource group - follows naming convention rg-<project>-<env>-<###>"
  type        = string
  # No default - must be provided via terraform.tfvars
}

variable "prefix" {
  description = "Prefix for resource names - combines project and environment for backward compatibility"
  type        = string
  # No default - must be provided via terraform.tfvars
}

#--------------------------------------------
# Network Configuration Variables
# Purpose: Defines VNet and subnet addressing for network segmentation
#--------------------------------------------

variable "vnet_address_space" {
  description = "CIDR block for virtual network - development uses 10.1.0.0/16 (65,536 IPs)"
  type        = string
  default     = "10.0.0.0/16"    # Generic default - override in terraform.tfvars
}

variable "subnet_address_prefix" {
  description = "CIDR block for VM subnet - hosts virtual machines and compute resources"
  type        = string
  default     = "10.1.1.0/24"    # Development VM subnet (254 usable IPs)
}

variable "app_service_subnet_address_prefix" {
  description = "CIDR block for App Service VNet integration subnet - enables outbound connectivity to VNet"
  type        = string
  default     = "10.1.2.0/24"    # Development App Service subnet (254 usable IPs)
}

variable "private_endpoint_subnet_address_prefix" {
  description = "CIDR block for private endpoint subnet - hosts private endpoints for secure PaaS access"
  type        = string
  default     = "10.1.3.0/24"    # Development private endpoint subnet (254 usable IPs)
}

#--------------------------------------------
# Virtual Machine Configuration
# Purpose: Defines VM specifications and performance characteristics
#--------------------------------------------

variable "vm_size" {
  description = "Azure VM size/SKU - Standard_B2as_v2 provides 2 vCPU, 4GB RAM with burstable performance"
  type        = string
  default     = "Standard_B1s"    # Minimal default - override with B2as_v2 for development
}

variable "admin_username" {
  description = "Administrator username for VM login - used for SSH access"
  type        = string
  default     = "azureuser"    # Standard Azure VM username convention
}

variable "storage_account_type" {
  description = "VM OS disk storage type - Standard_LRS for dev, Premium_LRS for production"
  type        = string
  default     = "Premium_LRS"    # Performance default - override with Standard_LRS for cost optimization
}

#--------------------------------------------
# Security Configuration
#--------------------------------------------

variable "allowed_ssh_ip" {
  description = "Source IP address allowed for SSH access - use specific IP in production, '*' for development"
  type        = string
  default     = "*"    # Open for development - restrict in production environments
} 