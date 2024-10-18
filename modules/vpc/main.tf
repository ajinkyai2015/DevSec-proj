# Create a VPC resource with the given CIDR block
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "Main VPC"
  }
}
