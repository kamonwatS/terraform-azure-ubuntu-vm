#!/bin/bash

# Universal deployment script for all environments
# Usage: ./deploy.sh <environment>
# Example: ./deploy.sh dev

set -e

ENVIRONMENT=${1:-dev}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
WORKSPACE_DIR="$PROJECT_ROOT/environments/$ENVIRONMENT"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Terraform Deployment Script${NC}"
echo -e "${BLUE}================================${NC}"

# Validate environment
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo -e "${RED}❌ Environment '$ENVIRONMENT' not found${NC}"
    echo -e "${YELLOW}Available environments: dev, uat, production${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Deploying to: $ENVIRONMENT${NC}"
echo -e "${BLUE}📁 Working directory: $WORKSPACE_DIR${NC}"

# Change to environment directory
cd "$WORKSPACE_DIR"

# Additional confirmation for production
if [[ "$ENVIRONMENT" == "production" ]]; then
    echo -e "${YELLOW}⚠️  WARNING: This will deploy to PRODUCTION!${NC}"
    read -p "Type 'PRODUCTION' to confirm: " confirm
    if [[ "$confirm" != "PRODUCTION" ]]; then
        echo -e "${RED}❌ Production deployment cancelled${NC}"
        exit 1
    fi
fi

# Initialize Terraform if not already done
if [ ! -d ".terraform" ]; then
    echo -e "${BLUE}📦 Initializing Terraform...${NC}"
    terraform init
else
    echo -e "${GREEN}✅ Terraform already initialized${NC}"
fi

# Plan the deployment
echo -e "${BLUE}📋 Planning deployment for $ENVIRONMENT environment...${NC}"
terraform plan -out="tfplan-$ENVIRONMENT"

# Ask for confirmation
echo -e "${YELLOW}💭 Review the plan above${NC}"
read -p "Do you want to apply this plan? (y/N): " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    echo -e "${BLUE}🔨 Applying Terraform plan for $ENVIRONMENT environment...${NC}"
    terraform apply "tfplan-$ENVIRONMENT"
    
    # Display outputs
    echo ""
    echo -e "${GREEN}🎉 Deployment Complete for $ENVIRONMENT environment${NC}"
    echo -e "${BLUE}📊 Getting deployment details...${NC}"
    terraform output
    
    echo ""
    echo -e "${BLUE}🔐 To get the VM password, run:${NC}"
    echo -e "${YELLOW}terraform output -raw admin_password${NC}"
    
    echo ""
    echo -e "${GREEN}✨ Deployment successful!${NC}"
else
    echo -e "${YELLOW}❌ Deployment cancelled${NC}"
    # Clean up the plan file
    rm -f "tfplan-$ENVIRONMENT"
fi 