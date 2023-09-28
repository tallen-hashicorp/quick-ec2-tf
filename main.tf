terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# The number of instances required
variable "instance_count" {
  default = 3
}

# The Kay Pair name, this must be created mannualy before running
variable "key_name" {
  default = "tyler"
}

provider "aws" {
  region = "us-east-1"
}

##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_security_group" "ssh_access" {
  name        = "ssh_access_sg"
  description = "Security group allowing inbound SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "boundary_access" {
  name        = "boundary_access_sg"
  description = "Security group allowing inbound boundary access"

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_eip" "this" {
  count    = var.instance_count  
  vpc      = true
  instance = aws_instance.example[count.index].id
}

resource "aws_instance" "example" {
  count                       = var.instance_count
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.ssh_access.id}", "${aws_security_group.boundary_access.id}"]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "DELETE_ME"
  }
}

