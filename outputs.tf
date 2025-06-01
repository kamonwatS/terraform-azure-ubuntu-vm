output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_machine_name" {
  description = "Name of the virtual machine"
  value       = module.compute.vm_name
}

output "public_ip_address" {
  description = "Public IP address of the virtual machine"
  value       = module.compute.public_ip_address
}

output "private_ip_address" {
  description = "Private IP address of the virtual machine"
  value       = module.compute.private_ip_address
}

output "admin_username" {
  description = "Admin username for the VM"
  value       = module.compute.admin_username
}

output "admin_password" {
  description = "Admin password for the VM"
  value       = module.compute.admin_password
  sensitive   = true
}

output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${module.compute.admin_username}@${module.compute.public_ip_address}"
}

output "vm_size" {
  description = "Size of the virtual machine"
  value       = module.compute.vm_size
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.network.vnet_name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
} 