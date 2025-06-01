# 🚀 Deployment Guide

This guide covers how to deploy and manage your Azure Ubuntu VM infrastructure using the improved directory structure.

## 📋 Prerequisites

Before deploying, ensure you have:

1. **Azure CLI** installed and authenticated
2. **Terraform** >= 1.0 installed
3. **Make** utility (for using Makefile commands)
4. **jq** (optional, for JSON parsing in status commands)
5. **Azure subscription** with appropriate permissions

### Azure Authentication

```bash
# Login to Azure
az login

# Set your subscription (if you have multiple)
az account set --subscription "your-subscription-id"

# Verify your login
az account show
```

## 🏗️ Project Structure

```
terraform-azure-ubuntu-vm/
├── environments/           # Environment-specific configurations
│   ├── dev/               # Development environment
│   ├── uat/               # UAT environment
│   └── production/        # Production environment
├── modules/               # Reusable Terraform modules
├── scripts/               # Deployment and utility scripts
├── docs/                  # Documentation
└── Makefile              # Task automation
```

## 🚀 Quick Start

### Method 1: Using Makefile (Recommended)

```bash
# Deploy to development
make dev

# Deploy to UAT
make uat

# Deploy to production
make prod
```

### Method 2: Using Scripts Directly

```bash
# Deploy to any environment
./scripts/deploy.sh <environment>

# Examples:
./scripts/deploy.sh dev
./scripts/deploy.sh uat
./scripts/deploy.sh production
```

### Method 3: Manual Deployment

```bash
# Navigate to environment directory
cd environments/dev

# Initialize Terraform
terraform init

# Plan deployment
terraform plan -out=tfplan

# Apply deployment
terraform apply tfplan
```

## 🌍 Environment-Specific Deployment

### Development Environment

```bash
# Quick deployment
make dev

# Or using script
./scripts/deploy.sh dev

# Manual deployment
cd environments/dev
terraform init
terraform plan -out=tfplan-dev
terraform apply tfplan-dev
```

**Development Configuration:**
- VM Size: `Standard_B2as_v2` (2 vCPU, 4GB RAM)
- Network: `10.1.0.0/16`
- Cost: ~$35-40/month (with Spot pricing)
- Storage: Standard LRS

### UAT Environment

```bash
# Quick deployment
make uat

# Or using script
./scripts/deploy.sh uat
```

**UAT Configuration:**
- VM Size: `Standard_B2as_v2` (2 vCPU, 4GB RAM)
- Network: `10.2.0.0/16`
- Cost: ~$35-40/month (with Spot pricing)
- Storage: Standard LRS

### Production Environment

```bash
# Production deployment (requires confirmation)
make prod

# Or using script
./scripts/deploy.sh production
```

**Production Configuration:**
- VM Size: `Standard_B2as_v2` (2 vCPU, 4GB RAM)
- Network: `10.3.0.0/16`
- Cost: ~$35-40/month (with Spot pricing)
- Storage: Standard LRS
- **Additional confirmations required**

## 🔐 Security Considerations

### Production Deployment Safeguards

1. **Double Confirmation**: Production deployments require typing 'PRODUCTION' to confirm
2. **Manual Review**: Always review the plan before applying
3. **State Management**: Consider using remote state for production
4. **Access Control**: Limit who can deploy to production

### Password Management

After deployment, retrieve the auto-generated password:

```bash
# From environment directory
terraform output -raw admin_password

# Or use the full path
cd environments/dev && terraform output -raw admin_password
```

## 📊 Post-Deployment

### Verify Deployment

```bash
# Check resource status
make status-dev
make status-uat
make status-prod

# Get deployment outputs
cd environments/dev && terraform output
```

### Access Your VM

```bash
# Get connection details
terraform output ssh_connection_command

# Example output: ssh azureuser@<public-ip>
# Use the password from: terraform output -raw admin_password
```

### Common Post-Deployment Tasks

1. **Update System Packages**:
   ```bash
   ssh azureuser@<public-ip>
   sudo apt update && sudo apt upgrade -y
   ```

2. **Install Additional Software**:
   ```bash
   # Install Docker
   sudo apt install docker.io -y
   sudo usermod -aG docker azureuser
   ```

3. **Configure Firewall** (if needed):
   ```bash
   # Enable UFW
   sudo ufw enable
   sudo ufw allow ssh
   ```

## 🛠️ Troubleshooting

### Common Issues

1. **"Environment not found"**:
   - Ensure you're running from the project root
   - Check that the environment directory exists

2. **"No terraform state found"**:
   - Run `terraform init` in the environment directory
   - Ensure you've deployed to that environment

3. **VM Size Not Available**:
   - Check the current configuration in `terraform.tfvars`
   - Consider changing to a different VM size or region

4. **Authentication Issues**:
   - Verify Azure CLI login: `az account show`
   - Check subscription permissions

### Getting Help

```bash
# Show available make commands
make help

# Validate configuration
make validate

# Check script usage
./scripts/deploy.sh --help
```

## 🔄 Updates and Maintenance

### Updating Infrastructure

1. **Modify Configuration**:
   ```bash
   # Edit environment-specific settings
   nano environments/dev/terraform.tfvars
   ```

2. **Apply Changes**:
   ```bash
   make dev
   # or
   ./scripts/deploy.sh dev
   ```

### Regular Maintenance

```bash
# Format code
make format

# Validate configurations
make validate

# Clean temporary files
make clean

# Update Terraform providers
cd environments/dev && terraform init -upgrade
```

## 📈 Scaling

### Adding New Environments

1. Create new environment directory:
   ```bash
   mkdir environments/staging
   ```

2. Copy configuration from existing environment:
   ```bash
   cp environments/dev/* environments/staging/
   ```

3. Update configuration for new environment:
   ```bash
   nano environments/staging/terraform.tfvars
   ```

4. Add to Makefile and scripts as needed.

### Module Customization

- Modify modules in the `modules/` directory
- Test changes in development first
- Update all environments after validation

## 💰 Cost Management

### Cost Optimization

1. **Use Spot Instances**: Already configured for cost savings
2. **Right-size VMs**: Adjust VM sizes based on actual usage
3. **Schedule Shutdowns**: Use Azure Automation for non-production
4. **Monitor Usage**: Set up Azure Cost Management alerts

### Cost Estimation

```bash
# Placeholder for cost estimation
make cost-estimate
```

Consider using tools like:
- [Infracost](https://www.infracost.io/)
- Azure Cost Management
- Azure Pricing Calculator

## 🔒 Security Best Practices

1. **Enable Azure Security Center**
2. **Use Azure Key Vault** for secrets in production
3. **Implement Network Security Groups** (already configured)
4. **Regular Updates**: Keep OS and software updated
5. **Monitor Access**: Use Azure Monitor and Log Analytics

## 📝 Next Steps

After successful deployment, consider:

1. Setting up automated backups
2. Implementing monitoring and alerting
3. Configuring CI/CD pipelines
4. Setting up disaster recovery
5. Implementing Infrastructure as Code best practices 