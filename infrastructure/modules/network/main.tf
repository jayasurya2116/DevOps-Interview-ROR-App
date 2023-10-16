# Create the VPC network
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
}

# Create private and public subnets
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_cidr_blocks[count.index]
  availability_zone       = element(var.aws_region_names, count.index)
  map_public_ip_on_launch = false
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = element(var.aws_region_names, count.index)
  map_public_ip_on_launch = true
}

# Create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Create route tables and associate them with subnets
resource "aws_route_table" "incoming_routetable" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "in_rta_az1" {
  count         = length(var.private_subnet_cidr_blocks)
  subnet_id     = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.incoming_routetable.id
}

resource "aws_route_table_association" "in_rta_az2" {
  count         = length(var.public_subnet_cidr_blocks)
  subnet_id     = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.incoming_routetable.id
}


