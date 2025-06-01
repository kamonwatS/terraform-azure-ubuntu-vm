output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "public_ip_address" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.main.ip_address
}

output "private_ip_address" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.main.private_ip_address
}

output "admin_username" {
  description = "Admin username for the VM"
  value       = azurerm_linux_virtual_machine.main.admin_username
}

output "admin_password" {
  description = "Admin password for the VM"
  value       = random_password.vm_password.result
  sensitive   = true
}

output "vm_size" {
  description = "Size of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.size
} 