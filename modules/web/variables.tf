variable "public_subnet_ids" {
  description = "Public subnet IDs for web tier"
  type        = list(string)
}

variable "web_alb_sg_id" {
  description = "Security group ID for web ALB"
  type        = string
}

variable "web_instance_sg_id" {
  description = "Security group ID for web instances"
  type        = string
}

variable "web_ami" {
  description = "AMI ID for web tier instances"
  type        = string
}

variable "web_instance_type" {
  description = "Instance type for web tier"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = ""
}