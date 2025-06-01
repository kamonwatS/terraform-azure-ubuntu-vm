# Environment Configuration - Following Microsoft Azure Naming Convention
# Reference: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
environment         = "uat"
project_name        = "kai123"
prefix              = "kai123-uat"
location            = "Southeast Asia"
resource_group_name = "rg-kai123-uat-001"

# Network Configuration
vnet_address_space                      = "10.2.0.0/16"
subnet_address_prefix                   = "10.2.1.0/24"
app_service_subnet_address_prefix       = "10.2.2.0/24"
private_endpoint_subnet_address_prefix  = "10.2.3.0/24"
allowed_ssh_ip                          = "*"

# VM Configuration
vm_size              = "Standard_B2as_v2"  # 2 vCPU, 4GB RAM - better availability
storage_account_type = "Standard_LRS"  # Cheaper storage for UAT
admin_username       = "azureuser" 