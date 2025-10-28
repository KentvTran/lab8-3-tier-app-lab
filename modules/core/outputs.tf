# Subnet outputs
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "db_subnet_ids" {
  description = "List of database subnet IDs"
  value       = aws_subnet.database[*].id
}

# Security group outputs
output "web_alb_sg_id" {
  description = "Security group ID for web ALB"
  value       = aws_security_group.web_alb.id
}

output "web_instance_sg_id" {
  description = "Security group ID for web instances"
  value       = aws_security_group.web_instance.id
}

output "app_alb_sg_id" {
  description = "Security group ID for app ALB"
  value       = aws_security_group.app_alb.id
}

output "app_instance_sg_id" {
  description = "Security group ID for app instances"
  value       = aws_security_group.app_instance.id
}

output "db_sg_id" {
  description = "Security group ID for database"
  value       = aws_security_group.database.id
}