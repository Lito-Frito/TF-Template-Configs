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

resource "aws_default_security_group" "myapp-sg" {
  vpc_id = aws_vpc.myapp-vpc.id

  ingress = [var.ingress_list_of_ssh_fields, var.ingress_list_of_http_fields]
  egress  = [var.egress_list_of_fields]

  tags = {
    Name : "${var.env_prefix}-${var.__some_app__}-sg"
  }
}

# TODO: create my own image that has docker and other tools installed (e.g. WP or Pihole) to further customize implementation
data "aws_ami" "latest-amazon-image" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.aws_ami_name_filter]
  }
}

resource "aws_instance" "myapp-server" {
  ami                    = data.aws_ami.latest-amazon-image.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.myapp-key-pair.key_name
  subnet_id              = aws_subnet.myapp-subnet.id
  vpc_security_group_ids = [aws_default_security_group.myapp-sg.id]
  availability_zone      = var.availability_zone

  user_data = file(var.entrypoint_script_location)

  user_data_replace_on_change = true

  associate_public_ip_address = true
  tags = {
    Name : "${var.env_prefix}-${var.__some_app__}-server"
  }
}

resource "aws_key_pair" "myapp-key-pair" {
  key_name   = var.key_name
  public_key = file(var.public_key_location)
}

output "public_IP" {
  value = aws_instance.myapp-server.public_ip
}
