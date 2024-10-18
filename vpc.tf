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

output "private_subnet_1_id" {
  value = module.vpc.private_subnet_1_id
}

output "private_subnet_2_id" {
  value = module.vpc.private_subnet_2_id
}

output "private_instance_1_private_ip" {
  value = module.vpc.private_instance_1_private_ip
}

output "private_instance_2_private_ip" {
  value = module.vpc.private_instance_2_private_ip
}
