# 🚀 Terraform Azure Ubuntu VM Infrastructure

A production-ready, modular Terraform project for deploying Ubuntu 22.04 LTS virtual machines on Azure with support for multiple environments (dev, UAT, production).

## 🏗️ **Improved Directory Structure**

```
terraform-azure-ubuntu-vm/
├── README.md                    # This file
├── Makefile                     # Task automation
├── .gitignore                   # Git ignore rules
│
├── environments/                # 🌍 Environment-specific configurations
│   ├── dev/                    # Development environment
│   │   ├── main.tf             # Environment main configuration
│   │   ├── variables.tf        # Environment variables
│   │   ├── outputs.tf          # Environment outputs
│   │   ├── terraform.tfvars    # Environment values
│   │   └── backend.tf          # Remote state configuration
│   ├── uat/                    # UAT environment
│   └── production/             # Production environment
│
├── modules/                     # 🧩 Reusable Terraform modules
│   ├── compute/                # VM and related resources
│   ├── network/                # VNet, subnets, NSG
│   ├── storage/                # Storage accounts
│   └── vm-infrastructure/      # Combined infrastructure module
│
├── scripts/                     # 🔧 Automation scripts
│   ├── deploy.sh               # Universal deployment script
│   ├── destroy.sh              # Universal destroy script
│   ├── terraform.sh            # 🆕 Unified Terraform management script
│   ├── validate.sh             # Validation script
│   └── helpers/                # Helper scripts
│
├── docs/                       # 📚 Documentation
│   ├── DEPLOYMENT.md          # Detailed deployment guide
│   ├── ARCHITECTURE.md        # Architecture overview
│   └── diagrams/              # Architecture diagrams
│
├── configs/                    # ⚙️ Shared configurations
├── tests/                      # 🧪 Testing framework
└── tools/                      # 🛠️ Utility tools
```

## 🚀 **Quick Start**

### **Method 1: Using Makefile (Recommended)**

```bash
# Show all available commands
make help

# Deploy to development
make dev

# Deploy to UAT
make uat

# Deploy to production (with extra confirmations)
make prod

# Destroy environments
make destroy-dev
make destroy-uat
make destroy-prod
```

### **Method 2: Using Universal Scripts**

```bash
# Deploy to any environment
./scripts/deploy.sh <environment>

# Examples:
./scripts/deploy.sh dev
./scripts/deploy.sh uat
./scripts/deploy.sh production

# Destroy any environment
./scripts/destroy.sh <environment>
```

### **Method 3: Using Unified Terraform Script (New!)**

```bash
# Single script for all operations
./scripts/terraform.sh <action> <environment>

# Deploy examples:
./scripts/terraform.sh deploy dev
./scripts/terraform.sh deploy uat
./scripts/terraform.sh deploy production

# Other operations:
./scripts/terraform.sh destroy dev
./scripts/terraform.sh status uat
./scripts/terraform.sh plan production
./scripts/terraform.sh validate dev
./scripts/terraform.sh output prod
```

### **Method 4: Manual Deployment**

```bash
# Navigate to specific environment
cd environments/dev

# Initialize and deploy
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## 🌍 **Environment Configurations**

All environments use consistent, cost-optimized settings:

| Environment | VM Size | vCPU | RAM | Network | Monthly Cost* |
|-------------|---------|------|-----|---------|---------------|
| **Dev** | Standard_B2as_v2 | 2 | 4GB | 10.1.0.0/16 | ~$35-40 |
| **UAT** | Standard_B2as_v2 | 2 | 4GB | 10.2.0.0/16 | ~$35-40 |
| **Prod** | Standard_B2as_v2 | 2 | 4GB | 10.3.0.0/16 | ~$35-40 |

*\*With Spot pricing enabled for maximum cost savings*

## 📋 **Prerequisites**

1. **Azure CLI** installed and authenticated
2. **Terraform** >= 1.0 installed  
3. **Make** utility (for Makefile commands)
4. **Azure subscription** with appropriate permissions

### **Setup Azure Authentication**

```bash
# Login to Azure
az login

# Set subscription (if multiple)
az account set --subscription "your-subscription-id"

# Verify authentication
az account show
```

## 🎯 **Key Features**

### **🏗️ Modular Architecture**
- **Reusable modules** for compute, network, and storage
- **Environment isolation** with separate state files
- **Standardized configurations** across all environments

### **🔒 Security & Compliance**
- **Spot instances** for cost optimization
- **Network Security Groups** with SSH, HTTP, HTTPS rules
- **Auto-generated secure passwords**
- **Production deployment safeguards**

### **🛠️ Automation & DevOps**
- **Universal deployment scripts** with colored output
- **Makefile** for common tasks
- **Environment validation** and error handling
- **Clean destruction** with confirmation prompts

### **📊 Cost Optimization**
- **Azure Spot VMs** (up to 90% savings)
- **Standard LRS storage** for cost efficiency
- **Right-sized instances** for each environment
- **Built-in cost estimation** placeholders

## 🚀 **Deployment Examples**

### **Development Deployment**
```bash
# Quick deployment
make dev

# Check status
make status-dev

# Get VM details
cd environments/dev && terraform output
```

### **Production Deployment**
```bash
# Deploy with safety checks
make prod
# Requires typing 'PRODUCTION' to confirm

# Verify deployment
make status-prod
```

### **Multi-Environment Management**
```bash
# Deploy all environments
make dev && make uat && make prod

# Clean up temporary files
make clean

# Format all code
make format
```

## 🔧 **Common Tasks**

### **Get VM Access Information**
```bash
# Navigate to environment
cd environments/dev

# Get SSH command
terraform output ssh_connection_command

# Get password
terraform output -raw admin_password

# Example: ssh azureuser@<public-ip>
```

### **Update Infrastructure**
```bash
# Modify configuration
nano environments/dev/terraform.tfvars

# Apply changes
make dev
```

### **Validate Configuration**
```bash
# Validate all environments
make validate

# Format code
make format

# Initialize all environments
make init-all
```

## 💡 **Advanced Usage**

### **Remote State Management**

Each environment has backend configuration files for remote state:

```bash
# Enable remote state (example for dev)
cd environments/dev
# Edit backend.tf and uncomment the azurerm backend
terraform init -migrate-state
```

### **Adding New Environments**

```bash
# Create new environment
mkdir environments/staging
cp environments/dev/* environments/staging/

# Update configuration
nano environments/staging/terraform.tfvars

# Add to Makefile
# staging:
#     @scripts/deploy.sh staging
```

### **Module Development**

```bash
# Modify modules
nano modules/compute/main.tf

# Test in development first
make dev

# Apply to other environments
make uat && make prod
```

## 🛠️ **Troubleshooting**

### **Common Issues**

1. **"Environment not found"**: Run from project root directory
2. **"VM size not available"**: Check region availability or change VM size
3. **"Authentication failed"**: Verify `az login` and subscription access
4. **"State locked"**: Wait for other operations to complete

### **Getting Help**

```bash
# Show make commands
make help

# Validate configurations
make validate

# Check Azure login
az account show
```

## 📚 **Documentation**

- 📖 **[Deployment Guide](docs/DEPLOYMENT.md)** - Comprehensive deployment instructions
- 🏗️ **[Architecture Guide](docs/ARCHITECTURE.md)** - System architecture overview  
- 🔧 **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions

## 🧪 **Testing**

```bash
# Run validation
make validate

# Test deployment in dev
make dev

# Verify outputs
make status-dev

# Clean up
make destroy-dev
```

## 🔐 **Security Notes**

- **Production requires double confirmation**
- **Auto-generated passwords** (16 characters with special chars)
- **Network security groups** configured with minimal required access
- **Consider Azure Key Vault** for production secrets
- **Enable Azure Security Center** for enhanced monitoring

## 💰 **Cost Management**

- **Spot pricing enabled** (up to 90% savings)
- **Standard LRS storage** for cost efficiency
- **Monitor usage** with Azure Cost Management
- **Set up budget alerts** for cost control

## 🚀 **Next Steps**

1. **Set up remote state** for production environments
2. **Implement CI/CD pipelines** for automated deployments
3. **Add monitoring and alerting** with Azure Monitor
4. **Configure automated backups** for production VMs
5. **Implement security scanning** with tools like tfsec

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test in development environment
5. Submit a pull request

## 📄 **License**

This project is licensed under the MIT License - see the LICENSE file for details.

---

**🎉 Happy Terraforming!** For questions or support, please refer to the documentation in the `docs/` directory or open an issue. 