
# Jenkins Server
module "jenkins" {
  source             = "./modules/ec2"
  ami                = "ami-005fc0f236362e99f"  # Ubuntu 20.04 AMI
  instance_type      = "t2.medium"
  subnet_id          = module.vpc.private_subnet_1_id  # Reference to private subnet 1
  key_name           = "cicd-pipeline"
  security_group_ids = [aws_security_group.ec2_sg.id]
  instance_name      = "Jenkins-Server"
  volume_size        = 20
}

# SonarQube Server
module "sonarqube" {
  source             = "./modules/ec2"
  ami                = "ami-005fc0f236362e99f"  # Ubuntu 20.04 AMI
  instance_type      = "t2.medium"
  subnet_id          = module.vpc.private_subnet_2_id  # Reference to private subnet 2
  key_name           = "cicd-pipeline"
  security_group_ids = [aws_security_group.ec2_sg.id]
  instance_name      = "SonarQube-Server"
  volume_size        = 20
}

# Nexus/Artifactory Server
module "nexus" {
  source             = "./modules/ec2"
  ami                = "ami-005fc0f236362e99f"  # Ubuntu 20.04 AMI
  instance_type      = "t2.medium"
  subnet_id          = module.vpc.private_subnet_2_id  # Reference to private subnet 2
  key_name           = "cicd-pipeline"
  security_group_ids = [aws_security_group.ec2_sg.id]
  instance_name      = "Nexus-Server"
  volume_size        = 20
}

# Security Group for all EC2 instances
resource "aws_security_group" "ec2_sg" {
  vpc_id = module.vpc.vpc_id  # Reference to the created VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS traffic
  }

  ingress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SMTP traffic
  }

  ingress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SMTPS traffic
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Kubernetes API traffic
  }

  ingress {
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Custom application ports
  }

  ingress {
    from_port   = 30000
    to_port     = 32768
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Custom high-range ports
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "ec2-sg"
  }
}
