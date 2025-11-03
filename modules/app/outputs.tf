output "aws_lb_dns_name" {
  description = "DNS name of the app (internal) Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "aws_lb_arn" {
  description = "ARN of the app (internal) Application Load Balancer"
  value       = aws_lb.app.arn
}

output "autoscaling_group_id" {
  description = "ID of the app Auto Scaling Group"
  value       = aws_autoscaling_group.app.id
}

