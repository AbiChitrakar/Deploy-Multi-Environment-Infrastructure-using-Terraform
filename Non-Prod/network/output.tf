output "vpc_id" {
  value = module.nonprod.vpc_id
}
output "public_subnet_ids" {
  value = module.nonprod.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.nonprod.private_subnet_ids
}

output "vpc_cidr" {
  value = module.nonprod.vpc_cidr
}

output "peering_route_table_id" {
  value = module.nonprod.peering_route_table_id
}

output "public_subnet_names" {
  description = "Names of the public subnets"
  value       = module.nonprod.public_subnet_names
}

output "private_subnet_names" {
  description = "Names of the private subnets"
  value       = module.nonprod.private_subnet_names
}

output "public_route_table_id" {
  description = "Public Route table id of first vpc"
  value       = module.nonprod.public_route_table_id
}