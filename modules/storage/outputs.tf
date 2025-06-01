output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.boot_diagnostics.id
}
 
output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.boot_diagnostics.name
} 