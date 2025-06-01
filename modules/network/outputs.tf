output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_id" {
  description = "ID of the VM subnet"
  value       = azurerm_subnet.internal.id
}

output "app_service_subnet_id" {
  description = "ID of the App Service VNet integration subnet"
  value       = azurerm_subnet.app_service.id
}

output "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet"
  value       = azurerm_subnet.private_endpoint.id
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.main.id
} 