output "vpc_peering_connection_id" {
  value = module.vpc_peering.vpc_peering_connection_id
}

output "vpc_peering_connection_status" {
  value = module.vpc_peering.vpc_peering_connection_status
}

output "requester_vpc_id" {
  value = module.vpc_peering.requester_vpc_id
}

output "accepter_vpc_id" {
  value = module.vpc_peering.accepter_vpc_id
}

output "auto_accept_status" {
  value = module.vpc_peering.auto_accept_status
}

