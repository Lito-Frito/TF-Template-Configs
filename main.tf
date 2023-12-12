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

resource "aws_vpc" "dev-vpc" {
  cidr_block = var.dev_vpc_cidr
  tags = {
    Name: "develonment"
  }
}

resource "aws_subnet" "dev-subnet" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.dev_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name: "develonment"
  }
}

