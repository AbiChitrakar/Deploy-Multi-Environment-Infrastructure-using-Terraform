# Instance type
variable "instance_type" {
  description = "Type of the instance"
  type        = string
}

# Variable to signal the current environment 
variable "env" {
  default     = "nonprod"
  type        = string
  description = "Deployment Environment"
}

variable "bastion_public_subnet" {
  type        = string
  description = "Bastion Public Subnet"
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "Assignment-01"
  description = "Name prefix"
}
