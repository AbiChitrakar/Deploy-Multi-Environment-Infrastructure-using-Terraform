resource "aws_vpc_peering_connection" "this" {
  vpc_id        = var.non_prod_vpc_id
  peer_vpc_id   = var.prod_vpc_id
  auto_accept   = var.auto_accept
  tags = {
    Name = "VPC-Peering"
  }
}

data "terraform_remote_state" "nonprod_network" {
  backend = "s3"
  config = {
    bucket = "acs730-project1-nonprod-abi"       // Your S3 bucket name
    key    = "NonProd-Network/terraform.tfstate" // The path to the state file
    region = "us-east-1"                         // The region where the bucket is located
  }
}

data "terraform_remote_state" "prod_network" {
  backend = "s3"
  config = {
    bucket = "acs730-project1-prod-abi"       // Your S3 bucket name
    key    = "Prod-Network/terraform.tfstate" // The path to the state file
    region = "us-east-1"                         // The region where the bucket is located
  }
}
resource "aws_route" "peer_route_to_prod" {
  route_table_id            =  data.terraform_remote_state.nonprod_network.outputs.public_route_table_id
  destination_cidr_block    = var.prod_vpc_cidr          
  vpc_peering_connection_id  = aws_vpc_peering_connection.this.id
}

resource "aws_route" "peer_route_to_non_prod" {
  route_table_id            =data.terraform_remote_state.prod_network.outputs.prod_peering_route_table_id# Use the passed route table ID
  destination_cidr_block    = var.non_prod_vpc_cidr      # CIDR of the non-prod VPC
  vpc_peering_connection_id  = aws_vpc_peering_connection.this.id  # Your peering connection
}
