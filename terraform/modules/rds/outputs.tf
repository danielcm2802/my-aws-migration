output "rds_endpoint" {
  description = "Writer endpoint of the RDS instance"
  value       = aws_db_instance.postgres_db.endpoint
  sensitive   = true
}

output "rds_port" {
  description = "PostgreSQL port"
  value       = aws_db_instance.postgres_db.port
}

output "rds_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.postgres_db.identifier
}

# output "rds_security_group_id" {
#   description = "ID of the RDS security group"
#   value       = aws_security_group.rds.id
# }
