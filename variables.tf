variable "db_user" {
  description = "Master username for the RDS database"
  type        = string
  sensitive   = true  # This hides the value in 'terraform plan' output
}

variable "db_password" {
  description = "Master password for the RDS database"
  type        = string
  sensitive   = true  # This also hides the value
}