
# Define the VPC
resource "aws_vpc" "k3s_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "k3s_vpc"
  }
}

# Create two subnets across different availability zones for the master nodes
resource "aws_subnet" "k3s_subnet" {
  count             = 1
  vpc_id            = aws_vpc.k3s_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "k3s_subnet"
  }
}

# Internet Gateway for internet access (if needed)
resource "aws_internet_gateway" "k3s_igw" {
  vpc_id = aws_vpc.k3s_vpc.id

  tags = {
    Name = "k3s_igw"
  }
}

# Route Table for the public subnets (if internet access is required)
resource "aws_route_table" "k3s_public_route_table" {
  vpc_id = aws_vpc.k3s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k3s_igw.id
  }

  tags = {
    Name = "k3s_public_route_table"
  }
}

resource "aws_route_table_association" "k3s_subnet_association" {
  count          = 1
  subnet_id      = aws_subnet.k3s_subnet[count.index].id
  route_table_id = aws_route_table.k3s_public_route_table.id
}
