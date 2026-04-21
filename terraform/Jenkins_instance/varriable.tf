variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  default     = "eu-west-1"
}

variable "my_enviroment" {
  description = "Instance type for the EC2 instance"
  default     = "dev"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "c7i-flex.large"
}

