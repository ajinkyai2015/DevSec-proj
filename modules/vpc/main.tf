# Create a VPC resource with the given CIDR block
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "cicd-project-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "cicd-project-igw"
  }
}

# Public Subnet for Bastion Host access
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  # Define CIDR block for public subnet
  availability_zone       = "us-east-1a"   # Adjust according to your region
  map_public_ip_on_launch = true

  tags = {
    Name = "cicd-project-public-subnet"
  }
}

# Route table for public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "cicd-project-public-route-table"
  }
}

# Route traffic to the Internet Gateway
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Bastion Host in the public subnet
resource "aws_instance" "bastion_host" {
  ami           = "ami-005fc0f236362e99f" # Replace with an appropriate AMI for your region
  instance_type = "t2.micro"  # Use the instance type you need
  subnet_id     = aws_subnet.public_subnet.id

  # Security group for Bastion host to allow SSH
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "cicd-project-bastion-host"
  }
}

# Security Group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from the internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cicd-project-bastion-sg"
  }
}

# Output the public subnet ID
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

# Output the public IP of the Bastion Host
output "bastion_host_public_ip" {
  description = "The public IP of the Bastion Host"
  value       = aws_instance.bastion_host.public_ip
}


# Find the latest Ubuntu 20.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]  # Canonical, the owner of official Ubuntu AMIs
}


# Private Subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"  # Define CIDR block for private subnet 1
  availability_zone       = "us-east-1a"   # Adjust according to your region
  map_public_ip_on_launch = false  # No public IPs for private subnet

  tags = {
    Name = "cicd-project-private-subnet-1"
  }
}

# Private Subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"  # Define CIDR block for private subnet 2
  availability_zone       = "us-east-1b"   # Adjust according to your region
  map_public_ip_on_launch = false  # No public IPs for private subnet

  tags = {
    Name = "cicd-project-private-subnet-2"
  }
}

# Security Group for private instances to allow SSH access only from the Bastion Host
resource "aws_security_group" "private_instance_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.bastion_host.private_ip}/32"]  # Allow SSH from Bastion Host's private IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cicd-project-private-instance-sg"
  }
}

# EC2 Instance in Private Subnet 1
resource "aws_instance" "private_instance_1" {
  ami           = data.aws_ami.ubuntu.id  # Use the dynamic AMI data source defined earlier
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_1.id

  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]

  tags = {
    Name = "cicd-project-private-instance-1"
  }
}

# EC2 Instance in Private Subnet 2
resource "aws_instance" "private_instance_2" {
  ami           = data.aws_ami.ubuntu.id  # Use the dynamic AMI data source defined earlier
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_2.id

  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]

  tags = {
    Name = "cicd-project-private-instance-2"
  }
}


