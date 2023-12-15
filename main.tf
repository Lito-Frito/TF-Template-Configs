terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.myapp_vpc_cidr
  tags = {
    Name : "${var.env_prefix}-${var.__some_app__}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.myapp_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name : "${var.env_prefix}-${var.__some_app__}-subnet"
  }
}

resource "aws_internet_gateway" "myapp-internet-gateway" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name : "${var.env_prefix}-${var.__some_app__}-internet_gateway"
  }
}

resource "aws_default_route_table" "myapp-default-route-table" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.myapp-internet-gateway.id
  }
  tags = {
    Name : "${var.env_prefix}-${var.__some_app__}-main_route_table"
  }
}

resource "aws_security_group" "myapp_sg" {
  name   = "${var.env_prefix}-${var.__some_app__}-sg"
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    description = "Allow SSH to VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr_block]
  }
  ingress = {
    description = "Allow HTTP to VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.route_table_cidr_block]
  }

  egress = {
    description = "Allow all outbound traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name : "${var.env_prefix}-${var.__some_app__}-sg"
  }
}
