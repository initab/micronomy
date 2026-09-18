data "aws_availability_zones" "available" {
  state = "available"
}


# VPC
resource "aws_vpc" "micronomy-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${local.app-name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.micronomy-vpc.id

  tags = {
    Name = "${local.app-name}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.micronomy-vpc.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.app-name}-public-subnet-${count.index + 1}"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.micronomy-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${local.app-name}-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security Group for ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "${local.app-name}-ecs-tasks-sg"
  description = "Allow inbound traffic for ECS tasks"
  vpc_id      = aws_vpc.micronomy-vpc.id

  ingress {
    description = "Allow HTTPS inbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.app-name}-ecs-tasks-sg"
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_ingress" {
  name        = "${local.app-name}-alb-ingress-sg"
  description = "Allow inbound traffic for ALB"
  vpc_id      = aws_vpc.micronomy-vpc.id

  ingress {
    description = "Allow HTTPS inbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.app-name}-alb-ingress-sg"
  }
}
