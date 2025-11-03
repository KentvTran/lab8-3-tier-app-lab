output "aws_lb_dns_name" {
  description = "DNS name of the web Application Load Balancer"
  value       = aws_lb.web.dns_name
}

output "aws_lb_arn" {
  description = "ARN of the web Application Load Balancer"
  value       = aws_lb.web.arn
}

output "autoscaling_group_id" {
  description = "ID of the web Auto Scaling Group"
  value       = aws_autoscaling_group.web.id
}

