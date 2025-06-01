.PHONY: help dev uat prod destroy-dev destroy-uat destroy-prod validate format clean init-all

# Default target
help:
	@echo "🚀 Terraform Azure Ubuntu VM - Available Commands:"
	@echo "=================================================="
	@echo ""
	@echo "📋 Deployment Commands:"
	@echo "  make dev          - Deploy development environment"
	@echo "  make uat          - Deploy UAT environment"
	@echo "  make prod         - Deploy production environment"
	@echo ""
	@echo "💥 Destruction Commands:"
	@echo "  make destroy-dev  - Destroy development environment"
	@echo "  make destroy-uat  - Destroy UAT environment"
	@echo "  make destroy-prod - Destroy production environment"
	@echo ""
	@echo "🔧 Utility Commands:"
	@echo "  make validate     - Validate all Terraform configurations"
	@echo "  make format       - Format all Terraform files"
	@echo "  make clean        - Clean temporary files and plans"
	@echo "  make init-all     - Initialize all environments"
	@echo ""
	@echo "📊 Status Commands:"
	@echo "  make status-dev   - Show dev environment status"
	@echo "  make status-uat   - Show UAT environment status"
	@echo "  make status-prod  - Show production environment status"
	@echo ""
	@echo "🚀 Unified Script Commands (Alternative):"
	@echo "  make tf-deploy-dev   - Deploy using unified script"
	@echo "  make tf-destroy-dev  - Destroy using unified script"
	@echo "  make tf-status-dev   - Status using unified script"
	@echo "  (Replace 'dev' with 'uat' or 'prod' for other environments)"
	@echo ""
	@echo "💡 Direct Script Usage:"
	@echo "  ./scripts/terraform.sh <action> <environment>"
	@echo "  Example: ./scripts/terraform.sh deploy dev"

# Deployment targets
dev:
	@echo "🚀 Deploying to development environment..."
	@scripts/deploy.sh dev

uat:
	@echo "🚀 Deploying to UAT environment..."
	@scripts/deploy.sh uat

prod:
	@echo "🚀 Deploying to production environment..."
	@scripts/deploy.sh production

# Destruction targets
destroy-dev:
	@echo "💥 Destroying development environment..."
	@scripts/destroy.sh dev

destroy-uat:
	@echo "💥 Destroying UAT environment..."
	@scripts/destroy.sh uat

destroy-prod:
	@echo "💥 Destroying production environment..."
	@scripts/destroy.sh production

# Validation and formatting
validate:
	@echo "🔍 Validating all Terraform configurations..."
	@scripts/validate.sh

format:
	@echo "🎨 Formatting all Terraform files..."
	@find . -name "*.tf" -exec terraform fmt {} \;
	@echo "✅ All Terraform files formatted"

# Clean temporary files
clean:
	@echo "🧹 Cleaning temporary files..."
	@find . -name "tfplan-*" -delete
	@find . -name "destroy-plan-*" -delete
	@find . -name ".terraform.lock.hcl" -delete
	@find . -name "*.backup" -delete
	@echo "✅ Cleanup completed"

# Initialize all environments
init-all:
	@echo "📦 Initializing all environments..."
	@cd environments/dev && terraform init
	@cd environments/uat && terraform init
	@cd environments/production && terraform init
	@echo "✅ All environments initialized"

# Status commands
status-dev:
	@echo "📊 Development environment status:"
	@cd environments/dev && terraform show -json | jq '.values.root_module.resources | length' 2>/dev/null || echo "No resources deployed"

status-uat:
	@echo "📊 UAT environment status:"
	@cd environments/uat && terraform show -json | jq '.values.root_module.resources | length' 2>/dev/null || echo "No resources deployed"

status-prod:
	@echo "📊 Production environment status:"
	@cd environments/production && terraform show -json | jq '.values.root_module.resources | length' 2>/dev/null || echo "No resources deployed"

# Security and compliance
security-scan:
	@echo "🔒 Running security scan..."
	@echo "Security scanning not implemented yet. Consider using tools like:"
	@echo "  - tfsec"
	@echo "  - checkov"
	@echo "  - terrascan"

# Cost estimation (placeholder)
cost-estimate:
	@echo "💰 Cost estimation..."
	@echo "Cost estimation not implemented yet. Consider using:"
	@echo "  - infracost"
	@echo "  - Azure Cost Management"

# Alternative unified script commands
tf-deploy-dev:
	@scripts/terraform.sh deploy dev

tf-deploy-uat:
	@scripts/terraform.sh deploy uat

tf-deploy-prod:
	@scripts/terraform.sh deploy production

tf-destroy-dev:
	@scripts/terraform.sh destroy dev

tf-destroy-uat:
	@scripts/terraform.sh destroy uat

tf-destroy-prod:
	@scripts/terraform.sh destroy production

tf-status-dev:
	@scripts/terraform.sh status dev

tf-status-uat:
	@scripts/terraform.sh status uat

tf-status-prod:
	@scripts/terraform.sh status production 