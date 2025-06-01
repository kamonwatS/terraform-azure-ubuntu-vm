variable "environment" {
  description = "Environment name (dev, uat, production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ubuntu-vm"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Southeast Asia"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_address_prefix" {
  description = "Address prefix for VM subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "app_service_subnet_address_prefix" {
  description = "Address prefix for App Service VNet integration subnet"
  type        = string
  default     = "10.1.2.0/24"
}

variable "private_endpoint_subnet_address_prefix" {
  description = "Address prefix for private endpoint subnet"
  type        = string
  default     = "10.1.3.0/24"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "storage_account_type" {
  description = "Storage account type for OS disk"
  type        = string
  default     = "Premium_LRS"
}

variable "allowed_ssh_ip" {
  description = "IP address allowed for SSH access"
  type        = string
  default     = "*"
} 