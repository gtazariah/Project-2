output "jenkins_public_ip" {
  description = "The public IP address of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_url" {
  description = "The URL to access the Jenkins server"
  value       = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}