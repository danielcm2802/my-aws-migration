# VPC
# ------------------------
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}



# subnets (per AZ)
# ------------------------
resource "aws_subnet" "public_sub" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-${var.availability_zones[count.index]}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_app_sub" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_app_subnet_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-private-app-${var.availability_zones[count.index]}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_db_sub" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_db_subnet_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-private-app-${var.availability_zones[count.index]}"
    Environment = var.environment

  }
}



# internet gateway
# ------------------------
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}



# NAT gateways
# ------------------------
resource "aws_eip" "nat_eip" {
  count  = length(var.availability_zones)
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-nat-eip"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.internet_gw]
}

resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_sub[count.index].id

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-gw"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.internet_gw]
}



# route table public subnets
# ---------------------------
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name        = "${var.project_name}-public-subnet-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_subnet_rta" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public_sub[count.index].id
  route_table_id = aws_route_table.public_subnet_rt.id
}



# route table private subnet app
# -------------------------------

resource "aws_route_table" "private_app_subnet_rt" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name        = "${var.project_name}-private-app-subnet-rt-${var.availability_zones[count.index]}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private_app_subnet_rta" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private_app_sub[count.index].id
  route_table_id = aws_route_table.private_app_subnet_rt[count.index].id
}



# route table private subnet DB
# -------------------------------
resource "aws_route_table" "private_db_subnet_rt" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project_name}-private-db-subnet-rt-${var.availability_zones[count.index]}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private_db_subnet_rta" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private_db_sub[count.index].id
  route_table_id = aws_route_table.private_db_subnet_rt[count.index].id
}



# vpc endpoints
# -------------------------------
resource "aws_vpc_endpoint" "s3_endpnt" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat(
    [aws_route_table.public_subnet_rt.id],
    aws_route_table.private_app_subnet_rt[*].id,
    aws_route_table.private_db_subnet_rt[*].id
  )

  tags = {
    Name        = "${var.project_name}-s3-endpoint"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_app_sub[*].id
  security_group_ids  = [var.ec2_sg_id]
  private_dns_enabled = true
}