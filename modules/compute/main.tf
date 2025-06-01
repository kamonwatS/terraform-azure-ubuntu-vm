#================================================
# Compute Module - Virtual Machine Infrastructure
# Purpose: Creates Ubuntu VM with supporting network components
# Features: Spot pricing, dynamic IP, password authentication
# Naming Convention: Microsoft Azure Cloud Adoption Framework
#================================================

#================================================
# Password Generation
# Purpose: Creates secure random password for VM admin user
# Configuration: 16 characters with special characters
# Security: Password is stored in Terraform state (use Key Vault in production)
#================================================

resource "random_password" "vm_password" {
  length  = 16        # 16-character password for security
  special = true      # Include special characters for complexity
}

#================================================
# Public IP Address
# Purpose: Provides internet connectivity for SSH access
# Naming: pip-<project>-<environment>-<region>-<###>
# Example: pip-kai123-dev-sea-001
# Configuration: Static allocation with Standard SKU for load balancer compatibility
#================================================

resource "azurerm_public_ip" "main" {
  name                = "pip-${var.project_name}-${var.environment}-sea-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"    # Static IP for consistent access
  sku                = "Standard"   # Standard SKU required for load balancers

  tags = var.tags
}

#================================================
# Network Interface
# Purpose: Connects VM to subnet and assigns IP addresses
# Naming: nic-<##>-vm<project>-<environment>-<###>
# Example: nic-01-vmkai123-dev-001
# Configuration: Dynamic private IP, static public IP
#================================================

resource "azurerm_network_interface" "main" {
  name                = "nic-01-vm${var.project_name}-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"                      # Internal IP configuration
    subnet_id                     = var.subnet_id                   # VM subnet from network module
    private_ip_address_allocation = "Dynamic"                       # Azure assigns private IP automatically
    public_ip_address_id          = azurerm_public_ip.main.id      # Attach public IP for internet access
  }

  tags = var.tags
}

#================================================
# Network Security Group Association
# Purpose: Applies firewall rules to the network interface
# Security: Associates NSG from network module with SSH, HTTP, HTTPS rules
# Dependencies: NSG created in network module
#================================================

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id    # Target network interface
  network_security_group_id = var.nsg_id                           # NSG from network module
}

#================================================
# Linux Virtual Machine
# Purpose: Main compute resource running Ubuntu 22.04 LTS
# Naming: vm-<project>-<environment>-<###>
# Example: vm-kai123-dev-001
# 
# Configuration Details:
# - OS: Ubuntu 22.04 LTS (Canonical)
# - Pricing: Spot instance for cost optimization
# - Authentication: Password-based (consider SSH keys for production)
# - Storage: Configurable disk type based on environment
#================================================

resource "azurerm_linux_virtual_machine" "main" {
  name                = "vm-${var.project_name}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size          # Configurable VM size (Standard_B2as_v2 for dev)
  admin_username      = var.admin_username   # azureuser

  #--------------------------------------------
  # Spot Instance Configuration
  # Benefits: Up to 90% cost savings for non-critical workloads
  # Risk: VM can be evicted when Azure needs capacity
  # Suitable for: Development, testing, batch processing
  #--------------------------------------------
  priority        = "Spot"                   # Enable Spot pricing
  eviction_policy = "Deallocate"            # Deallocate (don't delete) on eviction
  max_bid_price   = -1                       # Pay up to standard price (no limit)

  #--------------------------------------------
  # Authentication Configuration
  # Method: Password authentication (enabled for simplicity)
  # Production: Consider SSH key authentication for better security
  #--------------------------------------------
  disable_password_authentication = false                           # Enable password auth
  admin_password                  = random_password.vm_password.result  # Use generated password

  #--------------------------------------------
  # Network Configuration
  # Attachment: Links VM to network interface with public/private IPs
  #--------------------------------------------
  network_interface_ids = [
    azurerm_network_interface.main.id,        # Primary network interface
  ]

  #--------------------------------------------
  # Operating System Disk Configuration
  # Caching: ReadWrite for better performance
  # Storage: Configurable type (Standard_LRS for dev, Premium_LRS for prod)
  #--------------------------------------------
  os_disk {
    caching              = "ReadWrite"              # Enable disk caching for performance
    storage_account_type = var.storage_account_type # Configurable storage tier
  }

  #--------------------------------------------
  # VM Image Configuration
  # Publisher: Canonical (Ubuntu)
  # Offer: Ubuntu Server 22.04 LTS
  # SKU: 22_04-lts-gen2 (Generation 2 VM)
  # Version: Latest available
  #--------------------------------------------
  source_image_reference {
    publisher = "Canonical"                         # Ubuntu publisher
    offer     = "0001-com-ubuntu-server-jammy"     # Ubuntu 22.04 (Jammy)
    sku       = "22_04-lts-gen2"                    # LTS Gen2 for better performance
    version   = "latest"                            # Always use latest patch version
  }

  tags = var.tags
} 