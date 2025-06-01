#!/bin/bash

echo "🔍 Validating Terraform Configuration..."

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install Terraform first."
    echo "   You can install it with: sudo snap install terraform"
    exit 1
fi

# Initialize if needed
if [ ! -d ".terraform" ]; then
    echo "📦 Initializing Terraform..."
    terraform init
fi

# Validate configuration
echo "✅ Validating Terraform syntax..."
terraform validate

# Format check
echo "🎨 Checking code formatting..."
terraform fmt -check -recursive

# Plan for dev environment to test module structure
echo "📋 Testing plan for dev environment..."
terraform plan -var-file="terraform.tfvars.dev"

echo "✨ Validation complete!" 