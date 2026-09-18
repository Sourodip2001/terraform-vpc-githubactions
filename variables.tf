variable "cidr_block" {
  type = string
  description = "The cidr block for the VPC" 
}

variable "public_subnet_cidrs" {
  type = list(string)
  description = "The cidr blocks for the public subnets"
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "The cidr blocks for the private subnets"
}


variable "availability_zones" {
  type = list(string)
  description = "The availability zones for the subnets"
}

variable "availability_zone" {
  type = list(string)
  description = "The availability zone for the NAT gateway"
}

variable "enable_dns_hostnames" {
  type = bool
  description = "Enable DNS hostnames for the VPC"
}

variable "enable_dns_support" {
  type = bool
  description = "Enable DNS support for the VPC"
}