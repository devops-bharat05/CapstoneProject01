resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "capstone-eks-vpc"
  }
}

// internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "capstone-igw"
  }
}
// elastic Ip
resource "aws_eip" "nat_ip" {
  count = length(aws_subnet.public)
  domain   = "vpc"
}

// public subnet
resource "aws_subnet" "public" {
  count                  = length(var.public_subnet_cidrs)
  vpc_id                 = aws_vpc.this.id
  cidr_block             = element(var.public_subnet_cidrs, count.index)
  availability_zone      = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index}"
    "kubernetes.io/role/elb" = "1"
  }
}

// private subnet
resource "aws_subnet" "private" {
  count                  = length(var.private_subnet_cidrs)
  vpc_id                 = aws_vpc.this.id
  cidr_block             = element(var.private_subnet_cidrs, count.index)
  availability_zone      = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-${count.index}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

// 2. nat gateway
resource "aws_nat_gateway" "this" {
  count = length(aws_subnet.public)
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "capstone-gw-NAT  ${count.index}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}


// route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "capstone-public-route-table"
  }
}
// route (public)
resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.this.id
}
// route table association to public
resource "aws_route_table_association" "public_association" {
  count        = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
// route table for private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "capstone-private-route-table"
  }
}
// route for route table
resource "aws_route" "private_route" {
  count = length(aws_subnet.private)
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.this[count.index].id
}
// route table association to private
resource "aws_route_table_association" "private_association" {
  count = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


data "aws_availability_zones" "available" {
  state = "available"
}