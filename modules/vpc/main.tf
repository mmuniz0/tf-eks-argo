# vpc/main.tf

provider "aws" {
  region = "us-east-2"
}

# Create the VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = terraform.workspace
  }
}

# Create public subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "public-subnet-${terraform.workspace}"
  }
}

# Create private subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "private-subnet${terraform.workspace}"
  }
}

# Create an Internet Gateway to provide internet access to instances in public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gateway"
  }
}

# Attach the Internet Gateway to the VPC
# resource "aws_vpc_attachment" "gw_attachment" {
#   vpc_id             = aws_vpc.main.id
#   internet_gateway_id = aws_internet_gateway.gw.id
# }

# Create a route table for public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a security group for the EKS cluster
resource "aws_security_group" "eks_cluster_sg" {
  name_prefix = "eks-cluster-sg-"
  vpc_id      = aws_vpc.main.id

  # Ingress rule to allow incoming traffic from within the VPC (EKS worker nodes)
  ingress {
    description      = "Allow incoming traffic within the VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    security_groups  = [aws_security_group.eks_cluster_sg.id]
    self             = true
  }

  # Add any additional ingress/egress rules as needed for your use case
}

# Output the VPC ID and Subnet IDs for use in other modules
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}
 