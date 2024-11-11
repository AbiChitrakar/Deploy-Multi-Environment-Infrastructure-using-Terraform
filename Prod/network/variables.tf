variable "default_tags" {
  default = {
    "Owner" = "Abi",
    "Stack" = "Network"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "Assignment-01"
  description = "Name prefix"
}


# Provision private subnets in custom VPC
variable "private_subnet_cidr" {
  type        = list(string)
  description = "Private Subnet CIDRs"
}

# VPC CIDR range
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block for the nonprod environment."
}

variable "env" {
  type        = string
  default     = "prod"
  description = "Production environment"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "is_nonprod" {
  description = "Flag to determine if the environment is non-production"
  default     = false
  type        = bool
}