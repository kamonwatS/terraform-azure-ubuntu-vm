# Create Storage Account for boot diagnostics
resource "azurerm_storage_account" "boot_diagnostics" {
  name                     = "${replace(var.prefix, "-", "")}bootdiag"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
} 