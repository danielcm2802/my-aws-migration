variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnet_cidr" {
  type = list(string)
}
variable "private_db_subnet_cidr" {
  type = list(string)
}

variable "private_app_subnet_cidr" {
  type = list(string)
}
