# Azure Ubuntu VM Terraform Project (Modular)

This Terraform project provisions Azure Ubuntu VMs for three environments: **dev**, **uat**, and **production** using a modular architecture.

## 🏗️ Modular Architecture

The project is organized into reusable modules:

### 📁 Project Structure

```
.
├── main.tf                      # Root module calling child modules
├── variables.tf                 # Root variables
├── outputs.tf                   # Root outputs
├── versions.tf                  # Provider requirements
├── modules/
│   ├── network/
│   │   ├── main.tf             # VNet, subnet, NSG
│   │   ├── variables.tf        # Network variables
│   │   └── outputs.tf          # Network outputs
│   ├── compute/
│   │   ├── main.tf             # VM, NIC, public IP
│   │   ├── variables.tf        # Compute variables
│   │   └── outputs.tf          # Compute outputs
│   └── storage/
│       ├── main.tf             # Storage account
│       ├── variables.tf        # Storage variables
│       └── outputs.tf          # Storage outputs
├── terraform.tfvars.dev        # Development environment
├── terraform.tfvars.uat        # UAT environment
├── terraform.tfvars.production # Production environment
├── deploy-dev.sh               # Development deployment script
├── deploy-uat.sh               # UAT deployment script
├── deploy-production.sh        # Production deployment script
└── destroy.sh                  # Resource cleanup script
```

## 🔧 Module Details

### Network Module (`modules/network/`)
- **Virtual Network (VNet)**: Network foundation with environment-specific address spaces
- **Subnet**: Isolated network segment within the VNet
- **Network Security Group (NSG)**: Firewall rules for SSH, HTTP, and HTTPS

### Compute Module (`modules/compute/`)
- **Public IP**: Static public IP address for external access
- **Network Interface**: Connects VM to the network
- **Linux Virtual Machine**: Ubuntu 22.04 LTS with environment-appropriate sizing
- **Random Password**: Auto-generated secure password

### Storage Module (`modules/storage/`)
- **Storage Account**: For boot diagnostics

## 📋 Prerequisites

1. **Azure CLI** installed and authenticated
2. **Terraform** installed (version >= 1.0)
3. **Azure subscription** with appropriate permissions
4. **SSH key pair** (optional, password authentication is enabled by default)

### Azure Authentication

```bash
# Login to Azure
az login

# Set your subscription (if you have multiple)
az account set --subscription "your-subscription-id"
```

## 🚀 Quick Start

### 1. Clone and Initialize

```bash
# Navigate to the project directory
cd terraform

# Initialize Terraform (downloads modules and providers)
terraform init
```

### 2. Deploy to Development

```bash
# Deploy to dev environment
./deploy-dev.sh
```

### 3. Deploy to UAT

```bash
# Deploy to UAT environment
./deploy-uat.sh
```

### 4. Deploy to Production

```bash
# Deploy to production environment (requires additional confirmation)
./deploy-production.sh
```

## 🔧 Manual Deployment

If you prefer manual deployment:

```bash
# Plan deployment for specific environment
terraform plan -var-file="terraform.tfvars.dev" -out="tfplan-dev"

# Apply the plan
terraform apply "tfplan-dev"

# View outputs
terraform output
```

## 🌍 Environment Configurations

All environments now use uniform specifications for cost optimization:

### Development (dev)
- **VM Size**: Standard_B1s (1 vCPU, 1GB RAM)
- **Storage**: Standard_LRS
- **Network**: 10.1.0.0/16
- **Cost**: ~$15-20/month

### UAT (uat)
- **VM Size**: Standard_B1s (1 vCPU, 1GB RAM)
- **Storage**: Standard_LRS
- **Network**: 10.2.0.0/16
- **Cost**: ~$15-20/month

### Production (production)
- **VM Size**: Standard_B1s (1 vCPU, 1GB RAM)
- **Storage**: Standard_LRS
- **Network**: 10.3.0.0/16
- **Cost**: ~$15-20/month

## 🔐 Access Your VM

After deployment, get the connection details:

```bash
# View all outputs
terraform output

# Get the SSH connection command
terraform output ssh_connection_command

# Get the VM password (sensitive output)
terraform output -raw admin_password
```

### SSH Connection

```bash
# Replace with your actual IP and password
ssh azureuser@<public-ip-address>
```

## 🧹 Cleanup

To destroy resources for any environment:

```bash
# Destroy dev environment
./destroy.sh dev

# Destroy UAT environment
./destroy.sh uat

# Destroy production environment (requires additional confirmation)
./destroy.sh production
```

## 🔒 Security Features

- **Network Security Groups**: Configured with rules for SSH (22), HTTP (80), and HTTPS (443)
- **Strong Passwords**: Auto-generated 16-character passwords with special characters
- **Environment Isolation**: Separate VNets and resource groups per environment
- **Production Safeguards**: Additional confirmation prompts for production deployments
- **Modular Security**: Security rules centralized in network module

## 🎛️ Customization

### Modify VM Sizes

Edit the respective `terraform.tfvars.*` files:

```hcl
vm_size = "Standard_D4s_v3"  # Example: 4 vCPU, 16GB RAM
```

### Change Regions

Update the location in variable files:

```hcl
location = "West US 2"
```

### Adjust Network Configuration

Modify network settings in variable files:

```hcl
vnet_address_space    = "10.4.0.0/16"
subnet_address_prefix = "10.4.1.0/24"
```

### Module Customization

You can modify individual modules without affecting others:

- **Network changes**: Edit `modules/network/main.tf`
- **VM specifications**: Edit `modules/compute/main.tf`
- **Storage settings**: Edit `modules/storage/main.tf`

## 📊 Outputs

After deployment, you'll see these outputs:

- `resource_group_name`: Name of the created resource group
- `virtual_machine_name`: Name of the virtual machine
- `public_ip_address`: Public IP for external access
- `private_ip_address`: Private IP within the VNet
- `admin_username`: VM administrator username
- `admin_password`: VM administrator password (sensitive)
- `ssh_connection_command`: Ready-to-use SSH command
- `vm_size`: Configured VM size
- `environment`: Environment name
- `vnet_name`: Virtual network name
- `storage_account_name`: Storage account name

## 🚀 Module Benefits

### Advantages of Modular Approach:

1. **Reusability**: Modules can be reused across projects
2. **Maintainability**: Update modules independently
3. **Testing**: Test individual components in isolation
4. **Collaboration**: Teams can work on different modules
5. **Standardization**: Consistent infrastructure patterns
6. **Composition**: Mix and match modules as needed

### Module Dependencies:

```
Storage Module (independent)
    ↑
Network Module (independent)
    ↑
Compute Module (depends on Network)
```

## 🔄 Working with Modules

### Initialize After Changes

After modifying modules, run:

```bash
terraform init -upgrade
```

### Validate Module Structure

```bash
terraform validate
```

### Format Code

```bash
terraform fmt -recursive
```

## 🚨 Important Notes

1. **Costs**: All environments now use cost-optimized settings (~$15-20/month each)
2. **Security**: Change default passwords and consider using SSH keys for production
3. **Backups**: Set up automated backups for production VMs
4. **Updates**: Keep Ubuntu and applications updated
5. **Monitoring**: Consider setting up Azure Monitor for production workloads
6. **Module Versions**: Consider versioning modules for production use

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is licensed under the MIT License. 