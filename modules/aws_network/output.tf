# Outputs for VPC and Subnet IDs
output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

# output "peering_route_table_id" {
#   value = aws_route_table.Peering_Route_Table[*].id
# }
output "peering_route_table_id" {
  value       = var.env == "prod" ? aws_route_table.Peering_Route_Table[0].id : null
  description = "The route table ID for VPC peering in the prod environment"
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
 
}

output "public_subnet_names" {
  description = "Names of the public subnets"
  value       = aws_subnet.public_subnet[*].tags["Name"]
}

output "private_subnet_names" {
  description = "Names of the private subnets"
  value       = aws_subnet.private_subnet[*].tags["Name"]
}

output "public_route_table_id" {
  value       = var.env == "nonprod" ? aws_route_table.public_route_table[0].id : null
  description = "The ID of the public route table for the public subnet in the non-production environment."
}

output "prod_peering_route_table_id" {
  value = var.env == "prod" ? aws_route_table.Peering_Route_Table[0].id : null
}
