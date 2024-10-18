variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "subnet_id" {
  description = "The VPC subnet ID to launch the instance in"
  type        = string
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
}

variable "instance_name" {
  description = "The name to give the instance"
  type        = string
}

variable "volume_size" {
  description = "The size of the root EBS volume in GB"
  type        = number
  default     = 20  # 20 GB storage
}

variable "user_data" {
  description = "Optional user data script to run on instance boot"
  type        = string
  default     = null  # No user_data by default
}
