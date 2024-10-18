provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "bastion_host_public_ip" {
  description = "The public IP of the Bastion Host"
  value       = module.vpc.bastion_host_public_ip
}
