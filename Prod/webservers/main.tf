provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../modules/globalvars"
}


data "terraform_remote_state" "nonprod_network" {
  backend = "s3"
  config = {
    bucket = "acs730-project1-nonprod-abi"
    key    = "NonProd-Network/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "nonprod_webserver" {
  backend = "s3"
  config = {
    bucket = "acs730-project1-nonprod-abi"
    key    = "NonProd-Webserver/terraform.tfstate"
    region = "us-east-1"
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

# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = local.name_prefix
  public_key = file("~/.ssh/aws_ec2_key.pub")
}

# Security Group for VM1 and VM2 in Private Subnet
resource "aws_security_group" "private_vm_sg" {
  name        = "Private_VM_SG"
  description = "Allow HTTP and SSH inbound traffic from Bastion VM"
  vpc_id      = data.terraform_remote_state.prod_network.outputs.vpc_id

  ingress {
    description = "SSH access from Bastion VM"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.nonprod_webserver.outputs.vm_bastion_private_ip}/32"] # Assuming this output is the private IP
  }

  egress {
    description = "SSH access from Bastion VM"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [data.terraform_remote_state.nonprod_network.outputs.vpc_cidr]
  }



  tags = merge(local.default_tags, {
    "Name" = "${local.name_prefix}-private-vm-sg"
  })
}

# Define the mapping of VMs to private subnets
locals {
  vms = {
    "private-vm1" = data.terraform_remote_state.prod_network.outputs.private_subnet_ids[0]
    "private-vm2" = data.terraform_remote_state.prod_network.outputs.private_subnet_ids[1]
  }
}

# Create VM1 and VM2 in Private Subnets with a single Security Group
resource "aws_instance" "private_vms" {
  for_each = local.vms
  ami      = data.aws_ami.latest_amazon_linux.id
  key_name = aws_key_pair.web_key.key_name


  instance_type   = var.instance_type
  subnet_id       = each.value
  security_groups = [aws_security_group.private_vm_sg.id]

  tags = merge(local.default_tags, {
    "Name" = "VM-${var.env}-${each.key}"
  })
}
