output "vpc_peering_connection_id" {
  value       = aws_vpc_peering_connection.this.id
  description = "The ID of the VPC peering connection."
}

output "vpc_peering_connection_status" {
  value       = aws_vpc_peering_connection.this.accept_status
  description = "The status of the VPC peering connection."
}

output "requester_vpc_id" {
  value       = aws_vpc_peering_connection.this.vpc_id
  description = "The ID of the requester VPC."
}

output "accepter_vpc_id" {
  value       = aws_vpc_peering_connection.this.peer_vpc_id
  description = "The ID of the accepter VPC."
}

output "auto_accept_status" {
  value = aws_vpc_peering_connection.this.auto_accept
  description = "Indicates if the VPC peering connection is automatically accepted."
}
