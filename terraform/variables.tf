variable "project_name" {
  type    = string
  default = "my AWS migration"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}



# VPC variables
# -------------------
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the two public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for the two private app subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for the two private DB subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}



# EC2/ALB/ASG variables
# ----------------------
variable "instance_type" {
  description = "EC2 instance type for microservice nodes"
  type        = string
  default     = "t3.medium"
}

variable "asg_min_size" {
  description = "Minimum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 10
}

variable "asg_desired_capacity" {
  description = "Desired number of EC2 instances at launch"
  type        = number
  default     = 2
}

variable "microservice_images" {
  type = list(string)
  default = [
    "nginx:latest",
    "nginx:latest",
    "nginx:latest",
    "nginx:latest",
    "nginx:latest",
    "nginx:latest",
    "nginx:latest",
    "nginx:latest"
  ]
}



# DB variables
# ----------------
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.large"
}

variable "db_name" {
  description = "Name of the initial PostgreSQL database"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "dbadmin"
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS in GB"
  type        = number
  default     = 500
}

variable "db_backup_retention_days" {
  description = "Number of days to retain automated RDS backups"
  type        = number
  default     = 7
}



# Observability
# ----------------------
variable "cpu_alarm_threshold" {
  description = "CPU utilisation % threshold that triggers the CloudWatch alarm"
  type        = number
  default     = 80
}

variable "alb_5xx_threshold" {
  description = "ALB 5xx error rate % threshold that triggers a CloudWatch alarm"
  type        = number
  default     = 1
}

variable "alarm_email" {
  description = "Email address to receive CloudWatch alarm notifications"
  type        = string
  default     = "daniels.email@example.com"
}



# github credentials
# ------------------------
variable "github_user" {
  type    = string
  default = "danielcm2802"
}

variable "repo_name" {
  type    = string
  default = "my-aws-migration"
}

variable "acm_certificate_arn" {
  type    = string
  default = "arn:aws:acm:us-east-1:123456789012:certificate/dummy"
}