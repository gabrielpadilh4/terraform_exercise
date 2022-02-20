terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0341aeea105412b57"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.enable_ssh_http.id]


  tags = {
    Name = "cachethq-docker-instance"
  }
}

resource "aws_security_group" "enable_ssh_http" {
  name        = "enable_ssh_http"
  description = "Permite SSH e HTTP na instancia EC2"

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "CachetHq"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "enable_ssh_http"
  }
}
