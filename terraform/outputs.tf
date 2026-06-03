output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets (ALB / NAT Gateway)"
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the private app subnets (EC2 microservices)"
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs of the private DB subnets (RDS)"
  value       = module.vpc.private_db_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.ec2.alb_dns_name
}

output "rds_endpoint" {
  description = "Writer endpoint of the RDS Multi-AZ instance"
  value       = module.rds.rds_endpoint
  sensitive   = true
}

output "rds_port" {
  description = "Port the RDS instance listens on"
  value       = module.rds.rds_port
}

output "db_secret_arn" {
  description = "ARN of the Secrets Manager secret holding DB credentials"
  value       = module.iam.db_secret_arn
  sensitive   = true
}

output "ec2_instance_profile_name" {
  description = "Name of the IAM instance profile attached to EC2 nodes"
  value       = module.iam.ec2_instance_profile_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.ec2.asg_name
}

output "cloudwatch_log_group_names" {
  description = "Names of the CloudWatch Log Groups for each microservice"
  value       = module.observability.log_group_names
}