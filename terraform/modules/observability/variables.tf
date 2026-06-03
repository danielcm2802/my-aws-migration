variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "alarm_email" {
  type = string
}

variable "cpu_alarm_threshold" {
  type = number
}

variable "asg_name" {
  type = string
}

variable "alb_5xx_threshold" {
  type = number
}

variable "alb_arn_suffix" {
  type = string
}