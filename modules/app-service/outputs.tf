output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.main.name
}

output "app_service_id" {
  description = "ID of the App Service"
  value       = azurerm_linux_web_app.main.id
}

output "app_service_hostname" {
  description = "Default hostname of the App Service"
  value       = azurerm_linux_web_app.main.default_hostname
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = azurerm_service_plan.main.name
}

output "private_endpoint_ip" {
  description = "Private IP address of the App Service"
  value       = azurerm_private_endpoint.app_service.private_service_connection[0].private_ip_address
}

output "private_dns_zone_name" {
  description = "Name of the private DNS zone"
  value       = azurerm_private_dns_zone.app_service.name
} 