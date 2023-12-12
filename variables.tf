variable "region" {
  description = "value of the region infra is provisoned in"
}

variable "access_key" {
  description = "value of the access key for the aws account"
}

variable "secret_key" {
  description = "value of the secret key for the aws account"
}

variable "dev_vpc_cidr" {
    description = "value of the development vpc cidr block"
}

variable "dev_subnet_cidr" {
    description = "value of the development subnet cidr block"
}

variable "availability_zone" {
    description = "value of the availability zone for the development subnet"
}
