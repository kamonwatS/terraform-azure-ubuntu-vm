#================================================
# Storage Module - Boot Diagnostics and Logging
# Purpose: Creates storage account for VM diagnostics and monitoring
# Features: Standard LRS for cost optimization, secure access
# Naming Convention: Microsoft Azure Cloud Adoption Framework
#================================================

#================================================
# Storage Account for Boot Diagnostics
# Purpose: Stores VM boot logs, screenshots, and diagnostic data
# Naming: st<project><environment><###>
# Example: stkai123dev001
# 
# Configuration:
# - Tier: Standard (cost-effective for logs)
# - Replication: LRS (locally redundant storage)
# - Access: Secure by default
# 
# Use Cases:
# - VM boot diagnostics and troubleshooting
# - Serial console access logs
# - Performance monitoring data
# - Custom application logs (optional)
# 
# Benefits:
# - Enhanced VM troubleshooting capabilities
# - Boot failure analysis and resolution
# - Performance baseline monitoring
# - Compliance audit trail
#================================================

resource "azurerm_storage_account" "boot_diagnostics" {
  name                     = "st${var.project_name}${var.environment}001"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"    # Standard tier for cost optimization
  account_replication_type = "LRS"         # Locally Redundant Storage (most cost-effective)

  tags = var.tags
} 