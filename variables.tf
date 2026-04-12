variable "aws_region" {
  description = "Target AWS region (e.g., eu-west-2 for London, eu-west-1 for Dublin)"
  type        = string
  default     = "eu-west-2"
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
  default     = "SecurePass123!"
}

variable "instance_type" {
  description = "EC2 Instance size"
  type        = string
  default     = "t3.micro"
}