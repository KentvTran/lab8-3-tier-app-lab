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
- Internet-facing ALB
- Auto Scaling Group: 2-4 EC2 instances (t3.micro)
- Nginx web servers

**Tier 2 - Application Layer:**
- Private subnets (2 AZs)
- Internal ALB
- Auto Scaling Group: 2-4 EC2 instances (t3.micro)

**Tier 3 - Database Layer:**
- Isolated database subnets (2 AZs)
- RDS MySQL 5.7 (db.t3.micro, 20GB)

**Network:**
- VPC: 10.0.0.0/16
- 6 subnets across us-east-1a and us-east-1b
- Internet Gateway + NAT Gateway
- 5 security groups with tier isolation

## Project Structure
```
.
├── main.tf                # Root module
├── .gitignore
├── README.md
└── modules/
    ├── core/              # VPC, subnets, security groups
    ├── web/               # Web tier (ALB, ASG)
    ├── app/               # App tier (ALB, ASG)
    └── database/          # RDS MySQL
```

## Quick Start

### Prerequisites
- AWS Account with IAM permissions
- Terraform >= 1.0
- AWS CLI configured

### Deploy
```bash
# Get AMI for your region
aws ec2 describe-images \
  --region us-east-1 \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-2023*" \
            "Name=architecture,Values=x86_64" \
  --query "Images | sort_by(@, &CreationDate) | [-1].ImageId" \
  --output text

# Update AMI in main.tf, then deploy
terraform init
terraform plan
terraform apply -auto-approve

# IMPORTANT: Destroy after testing!
terraform destroy -auto-approve
```

## Key Features

- Modular Terraform design
- Multi-AZ high availability
- Auto scaling (2-4 instances per tier)
- Security group isolation (least privilege)
- Public + private subnet architecture
- Managed RDS database

## Configuration

**Region:** us-east-1  
**AMI:** Amazon Linux 2023 x86_64  
**Instance Types:** t3.micro  
**Database:** MySQL 5.7, db.t3.micro  

## Security

Five security groups implement strict tier isolation:
1. **web-alb-sg** → HTTP from internet
2. **web-instance-sg** → Traffic from web ALB only
3. **app-alb-sg** → Traffic from web instances only
4. **app-instance-sg** → Traffic from app ALB only
5. **db-sg** → MySQL from app instances only

