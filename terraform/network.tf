###################################
# VPC
###################################

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "sre-devops-vpc"
  }
}

###################################
# INTERNET GATEWAY
###################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sre-devops-igw"
  }
}

###################################
# SUBNET PÚBLICA
###################################

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  # hace la subnet pública
  map_public_ip_on_launch = true

  tags = {
    Name = "sre-devops-subnet"
  }
}

###################################
# ROUTE TABLE PÚBLICA
###################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "sre-devops-public-rt"
  }
}

###################################
# ASOCIACIÓN SUBNET → ROUTE TABLE
###################################

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public_rt.id
}

