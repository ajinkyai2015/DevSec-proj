resource "aws_instance" "ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }
   # Only include user_data if it is provided
  user_data = var.user_data

  tags = {
    Name = var.instance_name
  }
}
