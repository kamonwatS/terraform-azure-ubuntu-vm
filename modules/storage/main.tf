# Create Storage Account for boot diagnostics - Format: st<workload><environment><###>
resource "azurerm_storage_account" "boot_diagnostics" {
  name                     = "st${var.project_name}${var.environment}001"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
} 