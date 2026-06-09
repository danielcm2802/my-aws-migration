terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# RDS db postgres
# ---------------------
resource "aws_db_instance" "postgres_db" {
  identifier                 = "${var.project_name}-postgres"
  engine                     = "postgres"
  engine_version             = "15.4"
  instance_class             = var.db_instance_class
  allocated_storage          = var.db_allocated_storage
  storage_type               = "gp3"
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  db_name  = var.db_name
  username = var.db_username
  password = local.db_password

  multi_az = true

  db_subnet_group_name   = aws_db_subnet_group.db_sg.name
  vpc_security_group_ids = [var.rds_sg_id]
  publicly_accessible    = false

  storage_encrypted = true

  backup_retention_period = var.db_backup_retention_days

  deletion_protection       = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.project_name}-final-snapshot"

  tags = {
    Name        = "${var.project_name}-postgres"
    Environment = var.environment
  }
}


# gets password for db
# --------------------------------
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = var.db_password_secret_arn
}

locals {
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
}


# subnet group for multi AZ
# ----------------------------
resource "aws_db_subnet_group" "db_sg" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name        = "${var.project_name}-db-subnet-group"
    Environment = var.environment
  }
}