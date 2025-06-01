variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "project_name" {
  description = "Name of the project for naming convention"
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

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vnet_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "app_service_subnet_id" {
  description = "ID of the App Service VNet integration subnet"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 