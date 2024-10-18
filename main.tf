terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70"
    }
  }
  backend "s3" {
    bucket         = "cicd-statefile"
    key            = "terraform/statefile/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

module "iam" {
  source = "./modules/iam"
}

provider "aws" {
  region = "us-east-1"
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

# NAT Gateway in the public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = module.vpc.public_subnet_id  # Use public subnet from VPC module
}

# Route table for private subnet to route traffic through NAT Gateway
resource "aws_route" "private_route" {
  route_table_id         = module.vpc.private_route_table_id  # Use private route table from VPC module
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}