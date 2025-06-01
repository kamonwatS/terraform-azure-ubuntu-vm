#!/bin/bash

# Destroy resources for specified environment
if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    echo "Available environments: dev, uat, production"
    exit 1
fi

ENVIRONMENT=$1

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|uat|production)$ ]]; then
    echo "Invalid environment. Use: dev, uat, or production"
    exit 1
fi

echo "Destroying resources for $ENVIRONMENT environment..."

# Additional confirmation for production
if [[ "$ENVIRONMENT" == "production" ]]; then
    echo "WARNING: This will destroy PRODUCTION resources!"
    read -p "Type 'DESTROY PRODUCTION' to confirm: " confirm
    if [[ "$confirm" != "DESTROY PRODUCTION" ]]; then
        echo "Production destruction cancelled."
        exit 1
    fi
fi

# Destroy resources
terraform destroy -var-file="terraform.tfvars.$ENVIRONMENT" -auto-approve

echo "Resources for $ENVIRONMENT environment have been destroyed." 