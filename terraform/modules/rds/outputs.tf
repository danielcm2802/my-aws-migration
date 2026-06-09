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
