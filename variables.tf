variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-0b6d9d3d33ba97d99" # Example AMI ID, replace with a valid one for your region  
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the EC2 instance"
  type        = string
  default     = "aws-us-east-1" # Replace with your actual key pair name     
}

variable "my_ip" {
  description = "The IP address of the client machine"
  type        = string
  default     = "117.193.153.167/32" # Replace with your actual IP address
}