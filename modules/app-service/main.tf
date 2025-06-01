# Create App Service Plan (Basic B1) - Format: plan-<workload>-<environment>-<###>
resource "azurerm_service_plan" "main" {
  name                = "plan-${var.project_name}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = var.tags
}

# Create App Service - Format: app-<workload>-<environment>-<###>
resource "azurerm_linux_web_app" "main" {
  name                = "app-${var.project_name}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  # Disable public network access
  public_network_access_enabled = false

  site_config {
    always_on = true
    
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "ENVIRONMENT" = var.environment
  }

  tags = var.tags
}

# VNet Integration for App Service
resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  app_service_id = azurerm_linux_web_app.main.id
  subnet_id      = var.app_service_subnet_id
}

# Private DNS Zone for App Service
resource "azurerm_private_dns_zone" "app_service" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "app_service" {
  name                  = "pdnslink-${var.project_name}-${var.environment}-001"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.app_service.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false

  tags = var.tags
}

# Private Endpoint for App Service - Format: pe-<service>-<workload>-<environment>-<###>
resource "azurerm_private_endpoint" "app_service" {
  name                = "pe-app-${var.project_name}-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-app-${var.project_name}-${var.environment}-001"
    private_connection_resource_id = azurerm_linux_web_app.main.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "app-service-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.app_service.id]
  }

  tags = var.tags
} 