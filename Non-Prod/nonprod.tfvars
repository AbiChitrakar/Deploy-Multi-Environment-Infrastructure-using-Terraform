vpc_cidr             = "10.1.0.0/16"
public_subnet_cidr   = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidr  = ["10.1.3.0/24", "10.1.4.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]
bastion_public_subnet = "10.1.2.0/24"
is_nonprod           = true
instance_type        = "t2.micro"
key_name             =   "~/.ssh/aws_ec2_key"
prefix               = "Assignment-01"
default_tags         = {
  "Owner" = "Abi",
  "Stack"   = "Network",
  "Project" = "ACS-730"
}
env                  = "nonprod"