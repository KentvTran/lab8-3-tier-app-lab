variable "private_subnet_ids" {
  description = "Private subnet IDs for app tier"
  type        = list(string)
}

variable "app_alb_sg_id" {
  description = "Security group ID for app ALB"
  type        = string
}

variable "app_instance_sg_id" {
  description = "Security group ID for app instances"
  type        = string
}


variable "app_instance_type" {
  description = "Instance type for app tier"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID for the app target group"
  type        = string
}