# Instance type
variable "instance_type" {
  description = "Type of the instance"
  default     = "t2.micro"
  type        = string
}

# Variable to signal the current environment 
variable "env" {
  default     = "Prod"
  type        = string
  description = "Deployment Environment"
}

# variable "bastion_public_subnet" {
#   type        = string
#   description = "Bastion Public Subnet"
# }
