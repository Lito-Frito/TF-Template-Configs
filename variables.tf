variable "region" {
  description = "value of the region infra is provisoned in"
  type        = string
  default     = "us-east-1"
}

variable "access_key" {
  description = "value of the access key for the aws account"
  type        = string
}

variable "secret_key" {
  description = "value of the secret key for the aws account"
  type        = string
}

variable "__some_app__" { # Will be changed for each project
  description = "placeholder for the app name (e.g. web server or pihole)"
  type        = string
  default     = "__some_app__"
}

variable "myapp_vpc_cidr" {
  description = "value of the development vpc cidr block"
  default     = "10.0.0.0/16"
  type        = string
}

variable "myapp_subnet_cidr" {
  description = "value of the development subnet cidr block"
  default     = "10.0.10.0/24"
  type        = string
}

variable "availability_zone" {
  description = "value of the availability zone for the development subnet"
  type        = string
  default     = "us-east-1a"
}

variable "env_prefix" { # Will be changed for each project
  description = "value of the environment that is prefixed for respective infrastructure"
  type        = string
  default     = "development"
}

variable "route_table_cidr_block" {
  description = "value of the route table cidr block"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ingress_list_of_ssh_fields" {
  description = "list of values for the ssh ingress attribute in security group"
  type = object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    prefix_list_ids  = list(string)
    security_groups  = list(string)
    self             = bool
  })
  default = {
    description      = "Allow SSH to VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
}

variable "ingress_list_of_http_fields" { # For web app based projects
  description = "list of values for the http ingress attribute in security group"
  type = object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    prefix_list_ids  = list(string)
    security_groups  = list(string)
    self             = bool
  })
  default = {
    description      = "Allow HTTP to VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
}

variable "egress_list_of_fields" {
  description = "list of values for the egress attribute in security group"
  type = object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    prefix_list_ids  = list(string)
    security_groups  = list(string)
    self             = bool
  })
  default = {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
}

# variable "ami" {
#   description = "value of the ami to be used for the instance (default is Amazon Linux 2023 AMI)"
#   type = string
#   default = "ami-079db87dc4c10ac91"
# }

variable "ami_owner" {
  description = "value of the ami owner"
  type        = string
}

variable "aws_ami_name_filter" {
  description = "value of the ami name filter"
  type        = string
}

variable "instance_type" {
  description = "value of the instance type"
  type        = string
}

variable "key_name" {
  description = "value of the key name"
  type        = string
}

variable "public_key_location" {
  description = "value of the public key"
  type        = string
}

variable "entrypoint_script_location" {
  description = "value of the entrypoint script location"
  type        = string
  default     = "./entrypoint.sh"
}
