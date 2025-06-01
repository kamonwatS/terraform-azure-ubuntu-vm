# Infrastructure outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_machine_name" {
  description = "Name of the virtual machine"
  value       = module.compute.vm_name
}

output "vm_size" {
  description = "Size of the virtual machine"
  value       = module.compute.vm_size
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.network.vnet_name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
}

# VM Access outputs
output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = module.compute.public_ip_address
}

output "private_ip_address" {
  description = "Private IP address of the VM"
  value       = module.compute.private_ip_address
}

output "admin_username" {
  description = "Administrator username for the VM"
  value       = module.compute.admin_username
}

output "admin_password" {
  description = "Administrator password for the VM"
  value       = module.compute.admin_password
  sensitive   = true
}

output "ssh_connection_command" {
  description = "SSH connection command"
  value       = module.compute.ssh_connection_command
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

# App Service outputs
output "app_service_name" {
  description = "Name of the App Service"
  value       = module.app_service.app_service_name
}

output "app_service_private_ip" {
  description = "Private IP address of the App Service"
  value       = module.app_service.private_endpoint_ip
}

output "app_service_hostname" {
  description = "Hostname of the App Service (accessible only from VNet)"
  value       = module.app_service.app_service_hostname
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = module.app_service.app_service_plan_name
} 