#configure Terraform Cloud and AWS provider
terraform {
  #configure terraform cloud as backend 
  cloud {
    organization = "DevOps-Pilot1"
    workspaces {
      name = "practice-ec2-terraform"
    }
  }

  #cloud provider information
  required_providers {
    aws = { 
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

#Configure AWS provider
provider "aws" {
    region = var.aws_region

}

#Create VPC
resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
        Name             = "main-vpc"
        Environment      = var.environment

    }
  
}

#Create public Subnet 
resource "aws_subnet" "public" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.subnet_cidr
    availability_zone       = "$(var.aws_region)a"
    map_public_ip_on_launch = true
    tags = {
      Name    = "public-subnet"
      Environment = var.environment
    }
}

#Create Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name  = "main-igw"
      Environment = var.environment
    }
  
}

#Create Route Table
resource "aws_route_table" "public" {
    vpc_id     = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id

    }  
    tags = {
      Name        = "public-rt"
      Environment = var.environment
    }   
}

#Attach/Associate Routing table to Subnet
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id =  aws_route_table.public.id
  
}

#Create Security Group
resource "aws_security_group" "ec2_sg" {
    name ="ec2-security-group"
    vpc_id = aws_vpc.main.id

    #Inbound rules
    ingress {
        from_port          = 22
        to_port            = 22
        protocol           = "tcp"
        cidr_blocks   = ["0.0.0.0/0"] 
    }
    
    #Outbound rules
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "ec2-sg"
      Environment = var.environment
    } 
}

#Create EC2 Instance
resource "aws_instance" "web" {
    ami = var.instance_ami
    instance_type = var.instance_type

    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = true
     tags = {
       Name = var.instance_name
       Environment = var.environment
     }
}