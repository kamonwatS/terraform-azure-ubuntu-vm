# Environment Configuration - Following Microsoft Azure Naming Convention
# Reference: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
environment         = "production"
project_name        = "kai123"
prefix              = "kai123-prod"
location            = "Southeast Asia"
resource_group_name = "rg-kai123-prod-001"

# Network Configuration
vnet_address_space                      = "10.3.0.0/16"
subnet_address_prefix                   = "10.3.1.0/24"
app_service_subnet_address_prefix       = "10.3.2.0/24"
private_endpoint_subnet_address_prefix  = "10.3.3.0/24"
allowed_ssh_ip                          = "*"

# VM Configuration
vm_size              = "Standard_B2as_v2"  # 2 vCPU, 4GB RAM - production ready
storage_account_type = "Premium_LRS"  # Premium storage for production
admin_username       = "azureuser" 