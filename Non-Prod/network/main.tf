
# Module to deploy basic networking 
module "nonprod" {
  source              = "../../modules/aws_network"
  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.private_subnet_cidr
  private_subnet_cidr = var.public_subnet_cidr
  prefix              = var.prefix
  default_tags        = var.default_tags
  availability_zones  = var.availability_zones
  is_nonprod          = var.is_nonprod
}