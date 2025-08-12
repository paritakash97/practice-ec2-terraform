#aws_region 
variable "aws_region" {
    description = "aws region to deploy resources"
    type        = string
    default     = "us-east-1"  
}

#VPC CIDR
variable "vpc_cidr" {
    description  = "cidr block for vpc"
    type         = string 
    default      = "10.0.0.0/16" 
}

#subnet CIDR
variable "subnet_cidr" {
    description = "cidr block for subnet"
    type        = string
    default     = "10.0.1.0/24"
}

#EC2 configuration
variable "instance_type" {
    description = "ec2 instance type"
    type        = string
    default     = "t2.micro"  
}

#ISO image
variable "instance_ami" {
    description = "ec2 instance image id"
    type        = string
    default     = "ami-0de716d6197524dd9"
  
}

#Instance Name
variable "instance_name" {
    description = "name tag for ec2 instance"
    type        = string
    default     = "web-server"
}

#Environment Variable
variable "environment" {
    description = "environment name"
    type        = string
    default     = "dev"
}