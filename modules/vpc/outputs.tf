# Output the VPC ID
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

# Output private subnet 1 ID
output "private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
}

# Output private subnet 2 ID
output "private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
}

# Output EC2 instance private IPs
output "private_instance_1_private_ip" {
  value = aws_instance.private_instance_1.private_ip
}

output "private_instance_2_private_ip" {
  value = aws_instance.private_instance_2.private_ip
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id  # Output the ID of the private route table
}
