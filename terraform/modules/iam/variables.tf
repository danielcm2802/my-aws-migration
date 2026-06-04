variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "github_ssl" {
  type      = string
  default   = "6938fd4d98bab03faadb97b34396831e3780aea1"
  sensitive = true
}

variable "github_user" {
  type = string
}

variable "repo_name" {
  type = string
}