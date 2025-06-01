variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "project_name" {
  description = "Name of the project for naming convention"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, uat, production)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "nsg_id" {
  description = "ID of the network security group"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "storage_account_type" {
  description = "Storage account type for OS disk"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 