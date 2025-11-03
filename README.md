# 3-Tier AWS Architecture with Terraform

**CPSC 465 - Modern Software Development | Lab 8**  

https://medium.com/@sriharimalapati/building-a-scalable-3-tier-architecture-on-aws-using-terraform-a-modular-approach-5117378789f0

## Overview

Scalable 3-tier web application architecture on AWS using Terraform. Demonstrates Infrastructure as Code (IaC), high availability, and security best practices.

## Architecture
```
Internet → IGW → Web ALB → Web Tier (EC2)
                              ↓
                         NAT Gateway
                              ↓
                    App ALB → App Tier (EC2)
                              ↓
                         RDS MySQL
```

### Components

**Tier 1 - Web Layer:**
- Public subnets (2 AZs)
- Internet-facing ALB with health checks
- Auto Scaling Group: 2-4 EC2 instances (t3.micro)
- Python HTTP server (no external dependencies)

**Tier 2 - Application Layer:**
- Private subnets (2 AZs)
- Internal ALB
- Auto Scaling Group: 2-4 EC2 instances (t3.micro)

**Tier 3 - Database Layer:**
- Isolated database subnets (2 AZs)
- RDS MySQL 5.7 (db.t3.micro, 20GB)

**Network:**
- VPC: 10.0.0.0/16
- 6 subnets: Public (10.0.1-2/24), Private (10.0.3-4/24), Database (10.0.5-6/24)
- Internet Gateway + NAT Gateway
- 5 security groups with tier isolation

## Project Structure
```
.
├── main.tf                # Root module
├── outputs.tf             # Infrastructure outputs
├── .gitignore
├── README.md
└── modules/
    ├── core/              # VPC, subnets, security groups, routing
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── web/               # Web tier (ALB, target groups, ASG)
    │   ├── main.tf
    │   ├── data.tf        # Amazon Linux 2 AMI lookup
    │   ├── variables.tf
    │   └── outputs.tf
    ├── app/               # App tier (Internal ALB, ASG)
    │   ├── main.tf
    │   ├── data.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── database/          # RDS MySQL
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Quick Start

### Prerequisites
- AWS Account with IAM permissions (EC2, VPC, RDS, ELB)
- Terraform >= 1.0
- AWS CLI configured (`aws configure`)
- **Cost:** ~$0.60/day if left running

### Deploy
```bash
# Initialize and apply
terraform init
terraform plan
terraform apply -auto-approve

# Get website URL (wait 3-5 minutes for health checks)
terraform output web_alb_dns_name

# Test website
curl http://$(terraform output -raw web_alb_dns_name)
# Expected: <h1>Web Tier Works!</h1><p>Instance: ip-10-0-x-xxx</p>
```

### Verify Deployment
```bash
# Check target health
aws elbv2 describe-target-health \
  --target-group-arn $(aws elbv2 describe-target-groups --names web-tg \
    --query 'TargetGroups[0].TargetGroupArn' --output text) \
  --query 'TargetHealthDescriptions[*].[Target.Id,TargetHealth.State]' \
  --output table
# Should show: healthy

# List running instances
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress]' \
  --output table
```

### Clean Up
```bash
# IMPORTANT: Destroy to avoid charges
terraform destroy -auto-approve
```

## Outputs

After deployment, Terraform provides:
- `web_alb_dns_name` - Public website URL
- `app_alb_dns_name` - Internal app ALB
- `database_endpoint` - RDS connection string
- `vpc_id` - VPC ID
- `public_subnet_ids` - Web tier subnets
- `private_subnet_ids` - App tier subnets

## Key Features

- Modular Terraform design
- Multi-AZ high availability
- Auto Scaling (2-4 instances per tier)
- Security group isolation (least privilege)
- Public + private + database subnet separation
- Dynamic AMI lookup (latest Amazon Linux 2)
- Managed RDS database

## Configuration

**Region:** us-east-1  
**AMI:** Amazon Linux 2 (auto-detected)  
**Instance Types:** t3.micro  
**Database:** MySQL 5.7, db.t3.micro, 20GB  
**Auto Scaling:** Min: 2, Max: 4, Desired: 2

## Security

Five security groups enforce strict tier isolation:

1. **web-alb-sg** - HTTP (80) from internet
2. **web-instance-sg** - HTTP (80) from web-alb-sg only
3. **app-alb-sg** - HTTP (80) from web-instance-sg only
4. **app-instance-sg** - HTTP (80) from app-alb-sg only
5. **db-sg** - MySQL (3306) from app-instance-sg only


