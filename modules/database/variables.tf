variable "db_subnet_ids" {
  description = "Subnet IDs for database"
  type        = list(string)
}

variable "db_sg_id" {
  description = "Security group ID for database"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}