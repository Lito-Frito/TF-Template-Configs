terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.30.0"
    }
  }
}

provider "aws" {
    # Configuration options
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.myapp_vpc_cidr
  tags = {
    Name: "${var.env_prefix}-__some_app_-vpc"
  }
}

resource "aws_subnet" "myapp-subnet" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.myapp_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name: "${var.env_prefix}-__some_app__-subnet"
  }
}

