# AWS Migration Project

## Project Overview and Architecture Summary

This project builds and deploys a cloud infrastructure on AWS for an application composed of **8 microservices and a relational database (RDS)**. The infrastructure is fully defined using **Terraform** and follows a scalable, production-style microservices architecture.

### Architecture Overview

The system includes:

- A VPC with public and private subnets across multiple availability zones
- An Application Load Balancer (ALB) handling all incoming traffic
- EC2s that run microservices and are in an auto-scaling group
- A relational database (RDS) located in private subnets
- Security Groups controlling all service-to-service communication
- IAM roles for secure AWS access
- Modular Terraform design for maintainability and reuse

### System Flow

1. User traffic enters through the **ALB**
2. ALB routes requests to the correct **EC2 microservices**
3. Microservices communicate internally within the VPC
4. All database operations are handled by **RDS in a private subnet**

This ensures high security, scalability, and separation between application layers.
