output "web_alb_dns_name" {
  description = "Public DNS name of the web Application Load Balancer (website URL)"
  value       = module.web.aws_lb_dns_name
}

output "app_alb_dns_name" {
  description = "DNS name of the internal app Application Load Balancer"
  value       = module.app.aws_lb_dns_name
}

output "vpc_id" {
  description = "ID of the VPC created by the core module"
  value       = module.core.vpc_id
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.db_endpoint
}

output "public_subnet_ids" {
  description = "List of public subnet IDs from core module"
  value       = module.core.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs from core module"
  value       = module.core.private_subnet_ids
}

