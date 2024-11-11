# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Local variables
locals {
  default_tags = merge(
    var.default_tags,
    { "Env" = var.env }
  )
  name_prefix = "${var.prefix}-${var.env}"
}

# Create a new VPC 
resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = merge(
    local.default_tags, 
    {
      Name = "${local.name_prefix}-vpc"
    },
    var.default_tags
  )
}

# Add provisioning of the public subnetin the default VPC
resource "aws_subnet" "public_subnet" {
  count             = var.is_nonprod ? length(var.public_subnet_cidr[*]) : 0  # Create subnets only if non-prod
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    local.default_tags, {
      Name = "Public-Subnet-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    local.default_tags,
    {
      Name = "Private-Subnet-${count.index + 1}"
    }
  )
}

resource "aws_nat_gateway" "this" {
  count = var.is_nonprod ? 1 : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id    = aws_subnet.public_subnet[0].id

  tags = merge(
        local.default_tags,
    {
      Name = "${var.prefix}-nat-gateway"
    } )
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  
  vpc_id = aws_vpc.this.id

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-igw"
    }
  )
}

resource "aws_eip" "nat" {
  count = var.is_nonprod ? 1 : 0
  domain = "vpc"
}

# Route table to route add default gateway pointing to Internet Gateway (IGW)
resource "aws_route_table" "public_route_table" {
  count = var.is_nonprod ? 1 : 0
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env}-Public-Route_Table"
  }
}

# Associate subnets with the custom route table
resource "aws_route_table_association" "public_route_table_association" {
  # count          = length(aws_subnet.public_subnet[*].id)
  count          = var.is_nonprod ? length(aws_subnet.public_subnet[*]) : 0  # Only create associations if non-prod
  route_table_id = aws_route_table.public_route_table[0].id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.this.id  # Reference to your VPC
  # Route for outbound internet access to NAT Gateway for non-prod
  dynamic "route" {
    for_each = var.env == "nonprod" ? [1] : []  # Create route only if in non-prod environment
    content {
      cidr_block     = "0.0.0.0/0"  # Allow outbound traffic to the NAT Gateway
      nat_gateway_id = aws_nat_gateway.this[0].id  # Reference your NAT Gateway
    }
  }
  # Route for production environment to use the Internet Gateway
  dynamic "route" {
    for_each = var.env == "prod" ? [1] : []  # Create route only if in prod environment
    content {
      cidr_block = "0.0.0.0/0"  # Default route for other traffic
      gateway_id = aws_internet_gateway.igw.id  # Reference your Internet Gateway
    }
  }
  tags = {
    Name = "${var.env}-Private-Route-Table"
  }
}


# Associate Private Route Table with Private Subnets
resource "aws_route_table_association" "private_route_table_association" {
  count          = var.is_nonprod ? length(aws_subnet.private_subnet[*]) : 0  # Only create associations if non-prod
  # count          = length(aws_subnet.private_subnet[*].id)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# Route table for peering
resource "aws_route_table" "Peering_Route_Table" {
  count = var.is_nonprod ? 0 : 1
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.env}-Peering-Route_Table"
  }
}

resource "aws_route_table_association" "peering_route_table_association" {
  count          = var.env == "prod" ? length(aws_subnet.private_subnet[*]) : 0  # Only create associations if in prod
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.Peering_Route_Table[0].id  # Reference the Peering Route Table
}
