#!/bin/bash

# Deploy to Production Environment
echo "Deploying Ubuntu VM to Production Environment..."
echo "WARNING: This will deploy to PRODUCTION!"

# Double confirmation for production
read -p "Are you sure you want to deploy to PRODUCTION? Type 'PRODUCTION' to confirm: " confirm
if [[ $confirm != "PRODUCTION" ]]; then
    echo "Production deployment cancelled. You must type 'PRODUCTION' to confirm."
    exit 1
fi

# Initialize Terraform if not already done
if [ ! -d ".terraform" ]; then
    echo "Initializing Terraform..."
    terraform init
fi

# Plan the deployment
echo "Planning deployment for production environment..."
terraform plan -var-file="terraform.tfvars.production" -out="tfplan-production"

# Final confirmation
read -p "Do you want to apply this production plan? (y/N): " final_confirm
if [[ $final_confirm == [yY] || $final_confirm == [yY][eE][sS] ]]; then
    echo "Applying Terraform plan for production environment..."
    terraform apply "tfplan-production"
    
    # Display outputs
    echo ""
    echo "=== Production Deployment Complete ==="
    echo "Getting VM details..."
    terraform output
    
    echo ""
    echo "To get the VM password, run:"
    echo "terraform output -raw admin_password"
else
    echo "Production deployment cancelled."
fi 