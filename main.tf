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