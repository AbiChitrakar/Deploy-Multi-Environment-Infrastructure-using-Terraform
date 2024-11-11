variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "List of CIDR blocks for public subnets"
  default     = []
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "default_tags" {
  description = "Default tags for resources"
  type        = map(string)
}

variable "env" {
  type        = string
  description = " Declaring which Environment"
}

variable "is_nonprod" {
  description = "Flag to determine if the environment is non-production"
  type        = bool
}
