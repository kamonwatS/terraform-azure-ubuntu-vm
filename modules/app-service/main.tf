#================================================
# App Service Module - Secure PaaS Web Application Platform
# Purpose: Creates App Service with private connectivity and VNet integration
# Security: Public access disabled, accessible only via private endpoint
# Features: VNet integration, private DNS, automatic scaling
# Naming Convention: Microsoft Azure Cloud Adoption Framework
#================================================

#================================================
# App Service Plan
# Purpose: Defines compute resources and pricing tier for App Service
# Naming: plan-<project>-<environment>-<###>
# Example: plan-kai123-dev-001
# 
# Configuration:
# - Tier: Basic B1 (1 vCPU, 1.75GB RAM)
# - OS: Linux (cost-effective, better for containers)
# - Features: Custom domains, SSL, backups, staging slots
# 
# Scaling Options:
# - Basic: Manual scaling up to 3 instances
# - Standard/Premium: Auto-scaling available
#================================================

resource "azurerm_service_plan" "main" {
  name                = "plan-${var.project_name}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"    # Linux hosting for cost optimization
  sku_name            = "B1"       # Basic tier - suitable for development/testing

  tags = var.tags
}

#================================================
# Linux Web App (App Service)
# Purpose: Hosts web applications with enterprise-grade features
# Naming: app-<project>-<environment>-<###>
# Example: app-kai123-dev-001
# 
# Security Configuration:
# - Public access: DISABLED (private endpoint only)
# - Runtime: Node.js 18 LTS (long-term support)
# - Always On: Enabled (prevents cold starts)
# 
# Connectivity:
# - Inbound: Private endpoint only (secure)
# - Outbound: VNet integration (can access internal resources)
#================================================

resource "azurerm_linux_web_app" "main" {
  name                = "app-${var.project_name}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  #--------------------------------------------
  # Security Configuration
  # Critical: Disables public internet access
  # Access: Only through private endpoint within VNet
  # Benefits: Enhanced security, compliance, data sovereignty
  #--------------------------------------------
  public_network_access_enabled = false    # SECURITY: Block public access

  #--------------------------------------------
  # Application Configuration
  # Runtime: Node.js 18 LTS for modern web applications
  # Always On: Prevents cold starts and keeps app warm
  # Benefits: Better performance, faster response times
  #--------------------------------------------
  site_config {
    always_on = true    # Keep application instance warm
    
    # Runtime stack configuration
    application_stack {
      node_version = "18-lts"    # Node.js 18 Long Term Support
    }
  }

  #--------------------------------------------
  # Environment Variables
  # Purpose: Application configuration without code changes
  # Security: Non-sensitive configuration only
  # Best Practice: Use Key Vault for secrets
  #--------------------------------------------
  app_settings = {
    "ENVIRONMENT" = var.environment    # Environment identifier for app logic
  }

  tags = var.tags
}

#================================================
# VNet Integration (Outbound Connectivity)
# Purpose: Enables App Service to access resources within VNet
# Type: Regional VNet Integration (recommended)
# 
# Capabilities:
# - Access VMs, databases, storage within VNet
# - Access on-premises via VPN/ExpressRoute
# - Secure outbound communication
# 
# Requirements:
# - Dedicated subnet with delegation to Microsoft.Web/serverFarms
# - Subnet must not contain other Azure resources
#================================================

resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  app_service_id = azurerm_linux_web_app.main.id      # Target App Service
  subnet_id      = var.app_service_subnet_id          # Dedicated VNet integration subnet
}

#================================================
# Private DNS Zone
# Purpose: Resolves private endpoint FQDN to private IP addresses
# Zone: privatelink.azurewebsites.net (standard for App Service)
# 
# Functionality:
# - Maps app-kai123-dev-001.azurewebsites.net to private IP
# - Enables secure DNS resolution within VNet
# - Prevents DNS leakage to public internet
# 
# Integration:
# - Linked to VNet for automatic registration
# - Used by private endpoint for DNS records
#================================================

resource "azurerm_private_dns_zone" "app_service" {
  name                = "privatelink.azurewebsites.net"    # Standard App Service private zone
  resource_group_name = var.resource_group_name

  tags = var.tags
}

#================================================
# Private DNS Zone VNet Link
# Purpose: Associates private DNS zone with VNet
# Naming: pdnslink-<project>-<environment>-<###>
# Example: pdnslink-kai123-dev-001
# 
# Configuration:
# - Registration: Disabled (managed by private endpoint)
# - Resolution: Enabled (VNet resources can resolve private names)
# 
# Benefits:
# - Automatic DNS resolution for private endpoints
# - Secure name resolution within VNet boundary
#================================================

resource "azurerm_private_dns_zone_virtual_network_link" "app_service" {
  name                  = "pdnslink-${var.project_name}-${var.environment}-001"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.app_service.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false    # Private endpoint manages DNS records

  tags = var.tags
}

#================================================
# Private Endpoint (Inbound Connectivity)
# Purpose: Provides secure, private access to App Service
# Naming: pe-app-<project>-<environment>-<###>
# Example: pe-app-kai123-dev-001
# 
# Security Benefits:
# - Eliminates public internet exposure
# - Traffic stays within Azure backbone
# - Network-level access control via NSGs
# - Compliance with data residency requirements
# 
# Components:
# - Private IP address in dedicated subnet
# - Private service connection to App Service
# - DNS zone group for automatic record creation
# 
# Access Pattern:
# VM -> Private Endpoint -> App Service (secure internal communication)
#================================================

resource "azurerm_private_endpoint" "app_service" {
  name                = "pe-app-${var.project_name}-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id    # Dedicated private endpoint subnet

  #--------------------------------------------
  # Private Service Connection
  # Purpose: Connects private endpoint to App Service
  # Target: App Service resource
  # Subresource: 'sites' (web app endpoint)
  # Connection: Automatic approval
  #--------------------------------------------
  private_service_connection {
    name                           = "psc-app-${var.project_name}-${var.environment}-001"
    private_connection_resource_id = azurerm_linux_web_app.main.id    # Target App Service
    subresource_names              = ["sites"]                        # App Service sites endpoint
    is_manual_connection           = false                             # Automatic approval
  }

  #--------------------------------------------
  # DNS Zone Group
  # Purpose: Automatically creates DNS records in private zone
  # Effect: Maps App Service FQDN to private endpoint IP
  # Benefit: Seamless DNS resolution for private connectivity
  #--------------------------------------------
  private_dns_zone_group {
    name                 = "app-service-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.app_service.id]    # Link to private DNS zone
  }

  tags = var.tags
} 