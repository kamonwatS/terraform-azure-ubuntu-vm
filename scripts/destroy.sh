#!/bin/bash

# Universal destroy script for all environments
# Usage: ./destroy-universal.sh <environment>
# Example: ./destroy-universal.sh dev

set -e

ENVIRONMENT=${1}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
WORKSPACE_DIR="$PROJECT_ROOT/environments/$ENVIRONMENT"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${RED}💥 Terraform Destroy Script${NC}"
echo -e "${RED}============================${NC}"

# Validate environment parameter
if [ -z "$ENVIRONMENT" ]; then
    echo -e "${RED}❌ Usage: $0 <environment>${NC}"
    echo -e "${YELLOW}Available environments: dev, uat, production${NC}"
    exit 1
fi

# Validate environment exists
if [[ ! "$ENVIRONMENT" =~ ^(dev|uat|production)$ ]]; then
    echo -e "${RED}❌ Invalid environment. Use: dev, uat, or production${NC}"
    exit 1
fi

# Check if environment directory exists
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo -e "${RED}❌ Environment directory '$WORKSPACE_DIR' not found${NC}"
    exit 1
fi

echo -e "${YELLOW}⚠️  WARNING: This will destroy ALL resources in $ENVIRONMENT environment!${NC}"
echo -e "${BLUE}📁 Working directory: $WORKSPACE_DIR${NC}"

# Additional confirmation for production
if [[ "$ENVIRONMENT" == "production" ]]; then
    echo -e "${RED}🚨 DANGER: This will destroy PRODUCTION resources!${NC}"
    read -p "Type 'DESTROY PRODUCTION' to confirm: " confirm
    if [[ "$confirm" != "DESTROY PRODUCTION" ]]; then
        echo -e "${GREEN}✅ Production destruction cancelled. Safety first!${NC}"
        exit 1
    fi
else
    read -p "Type 'DESTROY $ENVIRONMENT' to confirm: " confirm
    if [[ "$confirm" != "DESTROY $ENVIRONMENT" ]]; then
        echo -e "${GREEN}✅ Destruction cancelled${NC}"
        exit 1
    fi
fi

# Change to environment directory
cd "$WORKSPACE_DIR"

# Check if terraform state exists
if [ ! -f "terraform.tfstate" ] && [ ! -f ".terraform/terraform.tfstate" ]; then
    echo -e "${YELLOW}⚠️  No terraform state found. Nothing to destroy.${NC}"
    exit 0
fi

echo -e "${BLUE}📋 Planning destruction for $ENVIRONMENT environment...${NC}"

# Plan the destruction first (optional but good practice)
terraform plan -destroy -out="destroy-plan-$ENVIRONMENT"

echo -e "${YELLOW}💭 Review the destruction plan above${NC}"
read -p "Proceed with destruction? (y/N): " final_confirm
if [[ $final_confirm == [yY] || $final_confirm == [yY][eE][sS] ]]; then
    echo -e "${RED}💥 Destroying resources for $ENVIRONMENT environment...${NC}"
    terraform apply "destroy-plan-$ENVIRONMENT"
    
    # Clean up plan file
    rm -f "destroy-plan-$ENVIRONMENT"
    
    echo ""
    echo -e "${GREEN}✅ Resources for $ENVIRONMENT environment have been destroyed${NC}"
    echo -e "${BLUE}🧹 Cleanup completed${NC}"
else
    echo -e "${GREEN}✅ Destruction cancelled${NC}"
    # Clean up the plan file
    rm -f "destroy-plan-$ENVIRONMENT"
fi 