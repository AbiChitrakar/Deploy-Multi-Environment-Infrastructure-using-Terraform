output "vpc_id" {
  value = module.prod.vpc_id
}

output "private_subnet_ids" {
  value = module.prod.private_subnet_ids
}

output "vpc_cidr" {
  value = module.prod.vpc_cidr
}

output "peering_route_table_id" {
  value = module.prod.peering_route_table_id
}

output "prod_peering_route_table_id" {
  value = module.prod.peering_route_table_id
}