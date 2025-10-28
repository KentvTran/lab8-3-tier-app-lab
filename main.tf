terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "core" {
  source = "./modules/core"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  db_subnet_cidrs      = ["10.0.5.0/24", "10.0.6.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
}

module "web" {
  source = "./modules/web"

  public_subnet_ids  = module.core.public_subnet_ids
  web_alb_sg_id      = module.core.web_alb_sg_id
  web_instance_sg_id = module.core.web_instance_sg_id
  web_ami            = "ami-07860a2d7eb515d9a"
  web_instance_type  = "t3.micro"
}

module "app" {
  source = "./modules/app"

  private_subnet_ids = module.core.private_subnet_ids
  app_alb_sg_id      = module.core.app_alb_sg_id
  app_instance_sg_id = module.core.app_instance_sg_id
  app_ami            = "ami-07860a2d7eb515d9a"
  app_instance_type  = "t3.micro"
}

module "database" {
  source = "./modules/database"
  
  db_subnet_ids = module.core.db_subnet_ids
  db_sg_id      = module.core.db_sg_id
  db_name       = "mydb"
db_user       = var.db_user       
  db_password   = var.db_password   
}