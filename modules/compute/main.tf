# Generate random password for VM
resource "random_password" "vm_password" {
  length  = 16
  special = true
}

# Create Public IP - Format: pip-<vm name or app name>-<environment>-<region>-<###>
resource "azurerm_public_ip" "main" {
  name                = "pip-${var.project_name}-${var.environment}-sea-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                = "Standard"

  tags = var.tags
}

# Create Network Interface - Format: nic-<##>-<vm name>-<subscription purpose>-<###>
resource "azurerm_network_interface" "main" {
  name                = "nic-01-vm${var.project_name}-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = var.tags
}

# Associate Network Security Group to the Network Interface
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = var.nsg_id
}

# Create Virtual Machine with Spot Instance pricing - Format: vm-<workload>-<environment>-<###>
resource "azurerm_linux_virtual_machine" "main" {
  name                = "vm-${var.project_name}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  # Spot instance configuration to comply with Azure policy
  priority        = "Spot"
  eviction_policy = "Deallocate"
  max_bid_price   = -1  # Pay up to the standard price

  disable_password_authentication = false
  admin_password                  = random_password.vm_password.result

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
} 