vpc_cidr             = "10.10.0.0/16"
# public_subnet_cidr   = []
private_subnet_cidr  = ["10.10.1.0/24", "10.10.2.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]
is_nonprod           = false
ami_id               = "ami-04d910c5029566cac"
instance_type        = "t2.micro"
prefix               = "Assignment-01"
default_tags         = {
  "Owner" = "Abi",
  "Project" = "ACS-730"
}
env                  = "prod"