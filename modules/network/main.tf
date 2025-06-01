#================================================
# Network Module - Virtual Network Infrastructure
# Purpose: Creates VNet with segmented subnets for different workloads
# Architecture: Hub-spoke design ready with security controls
# Naming Convention: Microsoft Azure Cloud Adoption Framework
#================================================

#================================================
# Virtual Network
# Purpose: Main network container for all subnets and resources
# Naming: vnet-<project>-<region>-<###>
# Example: vnet-kai123-sea-001
# 
# Address Space Planning:
# - Development: 10.1.0.0/16 (65,536 IP addresses)
# - UAT: 10.2.0.0/16 (65,536 IP addresses)
# - Production: 10.3.0.0/16 (65,536 IP addresses)
#================================================

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_name}-sea-001"
  address_space       = [var.vnet_address_space]    # Environment-specific CIDR block
  location            = var.location                 # Southeast Asia region
  resource_group_name = var.resource_group_name

  tags = var.tags
}

#================================================
# Virtual Machine Subnet
# Purpose: Hosts compute resources (VMs, VM Scale Sets)
# Naming: snet-<project>-vm-<region>-<###>
# Example: snet-kai123-vm-sea-001
# 
# Address Planning:
# - Dev: 10.1.1.0/24 (254 usable IPs)
# - UAT: 10.2.1.0/24 (254 usable IPs) 
# - Prod: 10.3.1.0/24 (254 usable IPs)
# 
# Security: Protected by Network Security Group
#================================================

resource "azurerm_subnet" "internal" {
  name                 = "snet-${var.project_name}-vm-sea-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_address_prefix]           # VM subnet CIDR
}

#================================================
# App Service VNet Integration Subnet
# Purpose: Enables App Service outbound connectivity to VNet resources
# Naming: snet-<project>-app-<region>-<###>
# Example: snet-kai123-app-sea-001
# 
# Address Planning:
# - Dev: 10.1.2.0/24 (254 usable IPs)
# - UAT: 10.2.2.0/24 (254 usable IPs)
# - Prod: 10.3.2.0/24 (254 usable IPs)
# 
# Requirements:
# - Dedicated subnet for App Service VNet integration
# - Must be delegated to Microsoft.Web/serverFarms
# - Cannot contain other Azure resources
#================================================

resource "azurerm_subnet" "app_service" {
  name                 = "snet-${var.project_name}-app-sea-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.app_service_subnet_address_prefix]  # App Service subnet CIDR

  #--------------------------------------------
  # Subnet Delegation for App Service
  # Purpose: Grants Azure App Service permission to manage this subnet
  # Requirement: Mandatory for VNet integration
  # Effect: Subnet becomes dedicated to App Service workloads
  #--------------------------------------------
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"                      # App Service delegation
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]  # Required permissions
    }
  }
}

#================================================
# Private Endpoint Subnet
# Purpose: Hosts private endpoints for secure connectivity to PaaS services
# Naming: snet-<project>-pe-<region>-<###>
# Example: snet-kai123-pe-sea-001
# 
# Address Planning:
# - Dev: 10.1.3.0/24 (254 usable IPs)
# - UAT: 10.2.3.0/24 (254 usable IPs)
# - Prod: 10.3.3.0/24 (254 usable IPs)
# 
# Use Cases:
# - App Service private endpoints
# - Storage account private endpoints
# - Database private endpoints
# - Key Vault private endpoints
#================================================

resource "azurerm_subnet" "private_endpoint" {
  name                 = "snet-${var.project_name}-pe-sea-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_endpoint_subnet_address_prefix]  # Private endpoint subnet CIDR
}

#================================================
# Network Security Group
# Purpose: Provides network-level security controls (Layer 4 firewall)
# Naming: nsg-<project>-<policy>-<###>
# Example: nsg-kai123-web-001
# 
# Security Rules:
# 1. SSH (Port 22) - Administrative access to VMs
# 2. HTTP (Port 80) - Web traffic for testing
# 3. HTTPS (Port 443) - Secure web traffic
# 
# Best Practices:
# - Principle of least privilege
# - Specific source IP ranges in production
# - Regular rule review and cleanup
#================================================

resource "azurerm_network_security_group" "main" {
  name                = "nsg-${var.project_name}-web-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  #--------------------------------------------
  # SSH Access Rule (Port 22)
  # Purpose: Allows SSH connections for VM management
  # Security: Configurable source IP (use specific IPs in production)
  # Priority: 1001 (higher priority than default rules)
  #--------------------------------------------
  security_rule {
    name                       = "SSH"
    priority                   = 1001                    # High priority
    direction                  = "Inbound"               # Incoming traffic
    access                     = "Allow"                 # Permit traffic
    protocol                   = "Tcp"                   # TCP protocol
    source_port_range          = "*"                     # Any source port
    destination_port_range     = "22"                    # SSH port
    source_address_prefix      = var.allowed_ssh_ip      # Configurable source IP
    destination_address_prefix = "*"                     # Any destination
  }

  #--------------------------------------------
  # HTTP Access Rule (Port 80)
  # Purpose: Allows HTTP connections for web services
  # Security: Open to internet (consider restricting in production)
  # Use Case: Development and testing web applications
  #--------------------------------------------
  security_rule {
    name                       = "HTTP"
    priority                   = 1002                    # Medium priority
    direction                  = "Inbound"               # Incoming traffic
    access                     = "Allow"                 # Permit traffic
    protocol                   = "Tcp"                   # TCP protocol
    source_port_range          = "*"                     # Any source port
    destination_port_range     = "80"                    # HTTP port
    source_address_prefix      = "*"                     # Any source (internet)
    destination_address_prefix = "*"                     # Any destination
  }

  #--------------------------------------------
  # HTTPS Access Rule (Port 443)
  # Purpose: Allows HTTPS connections for secure web services
  # Security: Open to internet for public web applications
  # Best Practice: Primary port for production web traffic
  #--------------------------------------------
  security_rule {
    name                       = "HTTPS"
    priority                   = 1003                    # Medium priority
    direction                  = "Inbound"               # Incoming traffic
    access                     = "Allow"                 # Permit traffic
    protocol                   = "Tcp"                   # TCP protocol
    source_port_range          = "*"                     # Any source port
    destination_port_range     = "443"                   # HTTPS port
    source_address_prefix      = "*"                     # Any source (internet)
    destination_address_prefix = "*"                     # Any destination
  }

  tags = var.tags
} 