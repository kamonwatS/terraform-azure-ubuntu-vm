#!/bin/bash

# Deploy to Development Environment
echo "Deploying Ubuntu VM to Development Environment..."

# Initialize Terraform if not already done
if [ ! -d ".terraform" ]; then
    echo "Initializing Terraform..."
    terraform init
fi

# Plan the deployment
echo "Planning deployment for dev environment..."
terraform plan -var-file="terraform.tfvars.dev" -out="tfplan-dev"

# Ask for confirmation
read -p "Do you want to apply this plan? (y/N): " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    echo "Applying Terraform plan for dev environment..."
    terraform apply "tfplan-dev"
    
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