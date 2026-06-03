
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_sub[*].id
}

output "private_app_subnet_ids" {
  description = "IDs of the private app subnets"
  value       = aws_subnet.private_app_sub[*].id
}

output "private_db_subnet_ids" {
  description = "IDs of the private DB subnets"
  value       = aws_subnet.private_db_sub[*].id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.nat_gw[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.internet_gw.id
}

output "s3_vpc_endpoint_id" {
  description = "ID of the S3 VPC Gateway Endpoint"
  value       = aws_vpc_endpoint.s3_endpnt.id
}
