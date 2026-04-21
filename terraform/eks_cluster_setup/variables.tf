variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  default     = "eu-west-1"
}

#variable "ami_id" {
#  description = "AMI ID for the EC2 instance"
# default     = "ami-085f9c64a9b75eed5"
#}



variable "my_enviroment" {
  description = "Instance type for the EC2 instance"
  default     = "dev"
}

variable "namespace" {
  description = "Namespace for the application"
  default     = "argo-cd"
}