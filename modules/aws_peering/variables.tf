variable "non_prod_vpc_id" {
  type        = string
  description = "The ID of the VPC initiating the peering connection (e.g., the non-production VPC)."
}

variable "prod_vpc_id" {
  type        = string
  description = "The ID of the VPC accepting the peering connection (e.g., the production VPC)."
}

variable "auto_accept" {
  type        = bool
  description = "Flag to indicate if the VPC peering connection should be automatically accepted by the accepter VPC."
}

variable "prod_vpc_cidr" {
  description = "The CIDR block of the production VPC"
  type        = string
}

variable "non_prod_vpc_cidr" {
  description = "The CIDR block of the non-production VPC"
  type        = string
}



variable "prod_peering_route_table_id" {
  description = "The ID of the Non-Prod route table for VPC peering"
  # type        = string
}