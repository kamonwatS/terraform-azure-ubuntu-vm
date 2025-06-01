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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 