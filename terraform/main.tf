terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


  # need to create before running terraform init
  # backend "s3" {
  #   bucket         = "my-aws-migration-tfstate"
  #   key            = "prod/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "my-aws-migration-tflock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  # can be removed if have account and OIDC arm
  access_key                  = "mock"
  secret_key                  = "mock"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}



# VPC folder
# ---------------
module "vpc" {
  source = "./modules/vpc"

  aws_region              = var.aws_region
  project_name            = var.project_name
  environment             = var.environment
  vpc_cidr                = var.vpc_cidr
  availability_zones      = var.availability_zones
  public_subnet_cidr      = var.public_subnet_cidrs
  private_app_subnet_cidr = var.private_app_subnet_cidrs
  private_db_subnet_cidr  = var.private_db_subnet_cidrs
  ec2_sg_id               = module.iam.ec2_security_group_id
}



# IAM folder
# ---------------
module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}



# EC2 folder
# ---------------
module "ec2" {
  source = "./modules/ec2"

  project_name           = var.project_name
  environment            = var.environment
  aws_region             = var.aws_region
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  instance_type          = var.instance_type
  ami_id                 = "mock variable" # put: data.aws_ami.amazon_linux.id and remove comment at line 139-147
  asg_min_size           = var.asg_min_size
  asg_max_size           = var.asg_max_size
  asg_desired_capacity   = var.asg_desired_capacity
  ec2_instance_profile   = module.iam.ec2_instance_profile_name
  ec2_sg_id              = module.iam.ec2_security_group_id
  alb_sg_id              = module.iam.alb_security_group_id
  log_groups_names       = module.observability.log_groups_names
  microservice_images    = var.microservice_images
  acm_certificate_arn    = var.acm_certificate_arn

}



# RDS folder
# ---------------
module "rds" {
  source                   = "./modules/rds"
  project_name             = var.project_name
  environment              = var.environment
  db_instance_class        = var.db_instance_class
  db_allocated_storage     = var.db_allocated_storage
  db_name                  = var.db_name
  db_username              = var.db_username
  db_backup_retention_days = var.db_backup_retention_days
  db_password_secret_arn   = module.iam.db_secret_arn
  private_db_subnet_ids    = module.vpc.private_db_subnet_ids
  rds_sg_id                = module.iam.rds_security_group_id

}



# observability folder
# -------------------------
module "observability" {
  source = "./modules/observability"

  project_name        = var.project_name
  environment         = var.environment
  alarm_email         = var.alarm_email
  cpu_alarm_threshold = var.cpu_alarm_threshold
  alb_5xx_threshold   = var.alb_5xx_threshold
  asg_name            = module.ec2.asg_name
  alb_arn_suffix      = module.ec2.alb_arn_suffix
}



# gets AWS AMI. no account so mock variable instead
# ---------------
# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }