output "region" {
  description = "The AWS region where resources are created"
  value       = aws_instance.testinstance.region
}

output "EC2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.testinstance.public_ip
}

output "EC2_public_dns" {
  description = "Public_DNS of the EC2 instance"
  value       = aws_instance.testinstance.public_dns
}