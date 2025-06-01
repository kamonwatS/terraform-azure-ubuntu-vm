# Create Virtual Network - Format: vnet-<subscription purpose>-<region>-<###>
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_name}-sea-001"
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Create Subnet - Format: snet-<subscription purpose>-<region>-<###>
resource "azurerm_subnet" "internal" {
  name                 = "snet-${var.project_name}-vm-sea-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_address_prefix]
}

# Create App Service VNet Integration Subnet
resource "azurerm_subnet" "app_service" {
  name                 = "snet-${var.project_name}-app-sea-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.app_service_subnet_address_prefix]

  # Required for App Service VNet integration
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Create Private Endpoint Subnet (for App Service Private Link)
resource "azurerm_subnet" "private_endpoint" {
  name                 = "snet-${var.project_name}-pe-sea-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_endpoint_subnet_address_prefix]
}

# Create Network Security Group and rules - Format: nsg-<policy name or app name>-<###>
resource "azurerm_network_security_group" "main" {
  name                = "nsg-${var.project_name}-web-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_ssh_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
} 