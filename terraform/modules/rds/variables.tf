variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_allocated_storage" {
  type = number
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_backup_retention_days" {
  type = number
}

variable "private_db_subnet_ids" {
  type = list(string)
}

variable "rds_sg_id" {
  type = string
}