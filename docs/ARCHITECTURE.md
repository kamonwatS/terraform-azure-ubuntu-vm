# Architecture Documentation

## Overview

This document provides a comprehensive overview of the **kai123** Azure infrastructure project, which implements a secure, scalable, and cost-optimized cloud architecture following Microsoft Azure Cloud Adoption Framework best practices.

## Project Information

- **Project Name**: kai123
- **Infrastructure as Code**: Terraform
- **Cloud Provider**: Microsoft Azure
- **Naming Convention**: [Microsoft Azure Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- **Environments**: Development, UAT, Production

## Architecture Overview

### High-Level Design

```
┌─────────────────────────────────────────────────────────────┐
│                     Azure Subscription                      │
├─────────────────────────────────────────────────────────────┤
│  Resource Group: rg-kai123-{env}-001                       │
│                                                             │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              Virtual Network                            │ │
│  │              vnet-kai123-sea-001                        │ │
│  │              Address Space: 10.{env}.0.0/16            │ │
│  │                                                         │ │
│  │  ┌──────────────┐ ┌──────────────┐ ┌─────────────────┐  │ │
│  │  │   VM Subnet  │ │ App Service  │ │ Private Endpoint│  │ │
│  │  │ 10.{env}.1.0 │ │   Subnet     │ │     Subnet      │  │ │
│  │  │    /24       │ │10.{env}.2.0  │ │  10.{env}.3.0   │  │ │
│  │  │              │ │    /24       │ │     /24         │  │ │
│  │  │ ┌──────────┐ │ │              │ │ ┌─────────────┐ │  │ │
│  │  │ │    VM    │ │ │              │ │ │   Private   │ │  │ │
│  │  │ │kai123-001│ │ │              │ │ │  Endpoint   │ │  │ │
│  │  │ └──────────┘ │ │              │ │ └─────────────┘ │  │ │
│  │  └──────────────┘ └──────────────┘ └─────────────────┘  │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                             │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                 App Service                             │ │
│  │            app-kai123-{env}-001                         │ │
│  │         (Public Access Disabled)                       │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                             │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              Storage Account                            │ │
│  │            stkai123{env}001                             │ │
│  │          (Boot Diagnostics)                             │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Component Details

### 1. Network Infrastructure

#### Virtual Network (VNet)
- **Purpose**: Main network container providing isolated network environment
- **Naming**: `vnet-kai123-sea-001`
- **Address Spaces**:
  - Development: `10.1.0.0/16` (65,536 IP addresses)
  - UAT: `10.2.0.0/16` (65,536 IP addresses)
  - Production: `10.3.0.0/16` (65,536 IP addresses)

#### Subnets

##### VM Subnet
- **Purpose**: Hosts virtual machines and compute resources
- **Naming**: `snet-kai123-vm-sea-001`
- **Address Ranges**:
  - Dev: `10.1.1.0/24` (254 usable IPs)
  - UAT: `10.2.1.0/24` (254 usable IPs)
  - Prod: `10.3.1.0/24` (254 usable IPs)

##### App Service Integration Subnet
- **Purpose**: Enables App Service outbound connectivity to VNet resources
- **Naming**: `snet-kai123-app-sea-001`
- **Requirements**: Delegated to `Microsoft.Web/serverFarms`
- **Address Ranges**:
  - Dev: `10.1.2.0/24` (254 usable IPs)
  - UAT: `10.2.2.0/24` (254 usable IPs)
  - Prod: `10.3.2.0/24` (254 usable IPs)

##### Private Endpoint Subnet
- **Purpose**: Hosts private endpoints for secure PaaS service connectivity
- **Naming**: `snet-kai123-pe-sea-001`
- **Address Ranges**:
  - Dev: `10.1.3.0/24` (254 usable IPs)
  - UAT: `10.2.3.0/24` (254 usable IPs)
  - Prod: `10.3.3.0/24` (254 usable IPs)

#### Network Security Group (NSG)
- **Purpose**: Network-level firewall (Layer 4)
- **Naming**: `nsg-kai123-web-001`
- **Rules**:
  - SSH (Port 22): Administrative access
  - HTTP (Port 80): Web traffic for testing
  - HTTPS (Port 443): Secure web traffic

### 2. Compute Infrastructure

#### Virtual Machine
- **Purpose**: Ubuntu-based compute resource with cost optimization
- **Naming**: `vm-kai123-{env}-001`
- **Configuration**:
  - OS: Ubuntu 22.04 LTS (Generation 2)
  - Size: Standard_B2as_v2 (2 vCPU, 4GB RAM)
  - Pricing: Spot instances for cost savings
  - Storage: Configurable (Standard_LRS for dev, Premium_LRS for prod)
  - Authentication: Password-based (consider SSH keys for production)

#### Supporting Resources
- **Public IP**: `pip-kai123-{env}-sea-001` (Static allocation)
- **Network Interface**: `nic-01-vmkai123-{env}-001`
- **Password**: Randomly generated 16-character password

### 3. Platform as a Service (PaaS)

#### App Service Plan
- **Purpose**: Compute resources for web applications
- **Naming**: `plan-kai123-{env}-001`
- **Configuration**:
  - Tier: Basic B1 (1 vCPU, 1.75GB RAM)
  - OS: Linux (cost-effective)
  - Features: Custom domains, SSL, backups

#### App Service (Web App)
- **Purpose**: Secure web application hosting
- **Naming**: `app-kai123-{env}-001`
- **Security**: Public access **DISABLED**
- **Runtime**: Node.js 18 LTS
- **Connectivity**:
  - Inbound: Private endpoint only
  - Outbound: VNet integration

#### Private Connectivity
- **Private Endpoint**: `pe-app-kai123-{env}-001`
- **Private DNS Zone**: `privatelink.azurewebsites.net`
- **DNS Link**: `pdnslink-kai123-{env}-001`

### 4. Storage Infrastructure

#### Storage Account
- **Purpose**: VM boot diagnostics and logging
- **Naming**: `stkai123{env}001`
- **Configuration**:
  - Tier: Standard (cost-effective)
  - Replication: LRS (Locally Redundant Storage)
  - Use Cases: Boot diagnostics, logs, troubleshooting data

## Security Architecture

### Network Security
1. **Segmented Subnets**: Workload isolation through subnet separation
2. **Network Security Groups**: Layer 4 firewall protection
3. **Private Endpoints**: Eliminates public internet exposure for PaaS services
4. **VNet Integration**: Secure outbound connectivity for App Service

### Access Control
1. **SSH Access**: Configurable source IP restrictions
2. **Private Connectivity**: App Service accessible only within VNet
3. **Principle of Least Privilege**: Minimal required permissions

### Data Protection
1. **Storage Security**: Secure by default configuration
2. **Transit Security**: HTTPS/TLS for all web communication
3. **Network Isolation**: Private communication paths

## Cost Optimization

### Development Environment
- **VM**: Spot pricing (up to 90% savings)
- **Storage**: Standard LRS (cost-effective)
- **App Service**: Basic B1 tier (minimal cost)

### Production Environment
- **Storage**: Premium LRS (performance optimization)
- **Monitoring**: Enhanced diagnostics and logging
- **Security**: Tightened access controls

## Disaster Recovery & High Availability

### Current State
- **Single Region**: Southeast Asia deployment
- **Storage Replication**: Locally Redundant Storage (LRS)
- **VM Recovery**: Spot instance with deallocation policy

### Future Enhancements
- **Multi-Region**: Deploy to paired Azure regions
- **Storage Upgrade**: Zone Redundant Storage (ZRS) or Geo-Redundant Storage (GRS)
- **Load Balancing**: Azure Load Balancer for high availability
- **Database**: Add Azure Database for PostgreSQL/MySQL with backup

## Monitoring & Observability

### Current Implementation
- **VM Diagnostics**: Boot diagnostics via storage account
- **Resource Tagging**: Environment and project identification

### Recommended Additions
- **Azure Monitor**: Comprehensive monitoring solution
- **Log Analytics**: Centralized log management
- **Application Insights**: Application performance monitoring
- **Alerts**: Proactive issue detection

## Compliance & Governance

### Naming Convention
- **Framework**: Microsoft Azure Cloud Adoption Framework
- **Consistency**: Standardized across all resources
- **Traceability**: Clear environment and project identification

### Tagging Strategy
- **Environment**: dev/uat/production
- **Project**: kai123
- **Cost Center**: (to be implemented)
- **Owner**: (to be implemented)

## Deployment Architecture

### Infrastructure as Code
- **Tool**: Terraform
- **Structure**: Modular design with reusable components
- **Environments**: Separate configurations for dev/uat/production

### Module Structure
```
modules/
├── compute/          # VM and related resources
├── network/          # VNet, subnets, NSG
├── storage/          # Storage accounts
└── app-service/      # App Service and private connectivity

environments/
├── dev/              # Development configuration
├── uat/              # UAT configuration
└── production/       # Production configuration
```

## Future Roadmap

### Phase 1 (Current)
- ✅ Basic infrastructure with VM and App Service
- ✅ Private connectivity implementation
- ✅ Cost optimization for development

### Phase 2 (Next)
- 🔄 Database integration (Azure Database for PostgreSQL)
- 🔄 Key Vault for secret management
- 🔄 Container support (Azure Container Instances/AKS)

### Phase 3 (Future)
- 📋 Multi-region deployment
- 📋 Advanced monitoring and alerting
- 📋 CI/CD pipeline integration
- 📋 Automated backup and recovery

## Best Practices Implemented

1. **Security First**: Private endpoints, network segmentation
2. **Cost Optimization**: Spot instances, appropriate storage tiers
3. **Scalability**: Modular design, configurable resources
4. **Maintainability**: Comprehensive documentation and comments
5. **Compliance**: Azure naming conventions, tagging strategy
6. **Infrastructure as Code**: Version-controlled, repeatable deployments 