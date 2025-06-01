#!/bin/bash

# 🚀 Terraform Management Script
# Universal script for all Terraform operations
# Usage: ./terraform.sh <action> <environment>
# Actions: deploy, destroy, validate, status, init, plan
# Environments: dev, uat, production

set -e

ACTION=${1}
ENVIRONMENT=${2}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
WORKSPACE_DIR="$PROJECT_ROOT/environments/$ENVIRONMENT"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Display usage
show_usage() {
    echo -e "${BLUE}🚀 Terraform Management Script${NC}"
    echo -e "${BLUE}==============================${NC}"
    echo ""
    echo -e "${GREEN}Usage:${NC}"
    echo -e "  $0 <action> <environment>"
    echo ""
    echo -e "${GREEN}Actions:${NC}"
    echo -e "  ${YELLOW}deploy${NC}     - Deploy infrastructure"
    echo -e "  ${YELLOW}destroy${NC}    - Destroy infrastructure"
    echo -e "  ${YELLOW}plan${NC}       - Show deployment plan"
    echo -e "  ${YELLOW}validate${NC}   - Validate configuration"
    echo -e "  ${YELLOW}status${NC}     - Show resource status"
    echo -e "  ${YELLOW}init${NC}       - Initialize Terraform"
    echo -e "  ${YELLOW}output${NC}     - Show outputs"
    echo ""
    echo -e "${GREEN}Environments:${NC}"
    echo -e "  ${CYAN}dev${NC}        - Development"
    echo -e "  ${CYAN}uat${NC}        - User Acceptance Testing"
    echo -e "  ${CYAN}production${NC} - Production"
    echo ""
    echo -e "${GREEN}Examples:${NC}"
    echo -e "  $0 deploy dev"
    echo -e "  $0 destroy uat"
    echo -e "  $0 status production"
    echo -e "  $0 validate dev"
}

# Validate inputs
if [ -z "$ACTION" ] || [ -z "$ENVIRONMENT" ]; then
    show_usage
    exit 1
fi

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|uat|production)$ ]]; then
    echo -e "${RED}❌ Invalid environment. Use: dev, uat, or production${NC}"
    exit 1
fi

# Check if environment directory exists
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo -e "${RED}❌ Environment directory '$WORKSPACE_DIR' not found${NC}"
    exit 1
fi

echo -e "${PURPLE}🔧 Terraform ${ACTION^} - ${ENVIRONMENT} Environment${NC}"
echo -e "${BLUE}================================================${NC}"

# Change to environment directory
cd "$WORKSPACE_DIR"

case $ACTION in
    "deploy")
        echo -e "${GREEN}🚀 Deploying to $ENVIRONMENT environment...${NC}"
        
        # Production confirmation
        if [[ "$ENVIRONMENT" == "production" ]]; then
            echo -e "${YELLOW}⚠️  WARNING: This will deploy to PRODUCTION!${NC}"
            read -p "Type 'PRODUCTION' to confirm: " confirm
            if [[ "$confirm" != "PRODUCTION" ]]; then
                echo -e "${RED}❌ Production deployment cancelled${NC}"
                exit 1
            fi
        fi

        # Initialize if needed
        if [ ! -d ".terraform" ]; then
            echo -e "${BLUE}📦 Initializing Terraform...${NC}"
            terraform init
        fi

        # Plan and apply
        terraform plan -out="tfplan-$ENVIRONMENT"
        echo -e "${YELLOW}💭 Review the plan above${NC}"
        read -p "Apply this plan? (y/N): " confirm
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
            terraform apply "tfplan-$ENVIRONMENT"
            echo -e "${GREEN}✅ Deployment complete!${NC}"
            terraform output
        else
            rm -f "tfplan-$ENVIRONMENT"
            echo -e "${YELLOW}❌ Deployment cancelled${NC}"
        fi
        ;;

    "destroy")
        echo -e "${RED}💥 Destroying $ENVIRONMENT environment...${NC}"
        
        # Confirmation based on environment
        if [[ "$ENVIRONMENT" == "production" ]]; then
            read -p "Type 'DESTROY PRODUCTION' to confirm: " confirm
            if [[ "$confirm" != "DESTROY PRODUCTION" ]]; then
                echo -e "${GREEN}✅ Production destruction cancelled${NC}"
                exit 1
            fi
        else
            read -p "Type 'DESTROY $ENVIRONMENT' to confirm: " confirm
            if [[ "$confirm" != "DESTROY $ENVIRONMENT" ]]; then
                echo -e "${GREEN}✅ Destruction cancelled${NC}"
                exit 1
            fi
        fi

        terraform plan -destroy -out="destroy-plan-$ENVIRONMENT"
        read -p "Proceed with destruction? (y/N): " final_confirm
        if [[ $final_confirm == [yY] || $final_confirm == [yY][eE][sS] ]]; then
            terraform apply "destroy-plan-$ENVIRONMENT"
            rm -f "destroy-plan-$ENVIRONMENT"
            echo -e "${GREEN}✅ Resources destroyed${NC}"
        else
            rm -f "destroy-plan-$ENVIRONMENT"
            echo -e "${GREEN}✅ Destruction cancelled${NC}"
        fi
        ;;

    "plan")
        echo -e "${BLUE}📋 Planning $ENVIRONMENT environment...${NC}"
        terraform plan
        ;;

    "validate")
        echo -e "${BLUE}🔍 Validating $ENVIRONMENT environment...${NC}"
        terraform validate
        echo -e "${GREEN}✅ Configuration valid${NC}"
        ;;

    "status")
        echo -e "${BLUE}📊 Status of $ENVIRONMENT environment:${NC}"
        if [ -f "terraform.tfstate" ]; then
            terraform show -json | jq '.values.root_module.resources | length' 2>/dev/null || echo "Resources deployed but can't count (jq not available)"
            echo ""
            terraform output 2>/dev/null || echo "No outputs available"
        else
            echo -e "${YELLOW}No state file found - no resources deployed${NC}"
        fi
        ;;

    "init")
        echo -e "${BLUE}📦 Initializing $ENVIRONMENT environment...${NC}"
        terraform init
        echo -e "${GREEN}✅ Terraform initialized${NC}"
        ;;

    "output")
        echo -e "${BLUE}📊 Outputs for $ENVIRONMENT environment:${NC}"
        terraform output
        ;;

    *)
        echo -e "${RED}❌ Unknown action: $ACTION${NC}"
        show_usage
        exit 1
        ;;
esac 