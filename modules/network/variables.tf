variable "prefix" {
  description = "Prefix for resource names"
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
  description = "Address prefix for subnet"
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