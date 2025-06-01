#!/bin/bash

# Deploy to UAT Environment
echo "Deploying Ubuntu VM to UAT Environment..."

# Initialize Terraform if not already done
if [ ! -d ".terraform" ]; then
    echo "Initializing Terraform..."
    terraform init
fi

# Plan the deployment
echo "Planning deployment for UAT environment..."
terraform plan -var-file="terraform.tfvars.uat" -out="tfplan-uat"

# Ask for confirmation
read -p "Do you want to apply this plan? (y/N): " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    echo "Applying Terraform plan for UAT environment..."
    terraform apply "tfplan-uat"
    
    # Display outputs
    echo ""
    echo "=== Deployment Complete ==="
    echo "Getting VM details..."
    terraform output
    
    echo ""
    echo "To get the VM password, run:"
    echo "terraform output -raw admin_password"
else
    echo "Deployment cancelled."
fi 