
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
    bucket = "acs730-project1-prod-abi"
    key    = "Prod-Network/terraform.tfstate"
    region = "us-east-1"
  }
}

module "vpc_peering" {
  source                      = "../modules/aws_peering"
  non_prod_vpc_id             = data.terraform_remote_state.nonprod_network.outputs.vpc_id # Reference to the non-prod VPC
  prod_vpc_id                 = data.terraform_remote_state.prod_network.outputs.vpc_id    # Reference to the prod VPC
  prod_peering_route_table_id = data.terraform_remote_state.prod_network.outputs.peering_route_table_id
  prod_vpc_cidr               = data.terraform_remote_state.prod_network.outputs.vpc_cidr # Replace with your actual prod CIDR
  non_prod_vpc_cidr           = data.terraform_remote_state.nonprod_network.outputs.vpc_cidr
  auto_accept                 = true # or true based on your requirement
}


output "prod_peering_route_table_id" {
  value = data.terraform_remote_state.prod_network.outputs.peering_route_table_id
}