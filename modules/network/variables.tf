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

variable "vnet_address_space" {
  description = "Address space for virtual network"
  type        = string
}

variable "subnet_address_prefix" {
  description = "Address prefix for VM subnet"
  type        = string
}

variable "app_service_subnet_address_prefix" {
  description = "Address prefix for App Service VNet integration subnet"
  type        = string
}

variable "private_endpoint_subnet_address_prefix" {
  description = "Address prefix for private endpoint subnet"
  type        = string
}

variable "allowed_ssh_ip" {
  description = "IP address allowed for SSH access"
  type        = string
  default     = "*"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 