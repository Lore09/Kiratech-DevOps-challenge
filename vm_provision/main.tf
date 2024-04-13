terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Master node
resource "aws_instance" "master" {
  
  instance_type = "t3.micro"
  ami = "ami-04f9a173520f395dd"
  tags = {
    Name = "master"
    Project = "DevOps Challenge"
  }
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.k3s_subnet[0].id}"
  vpc_security_group_ids = ["${aws_security_group.k3s_master_sg.id}"]
}

# Worker nodes
resource "aws_instance" "worker-1" {
  
  instance_type = "t3.micro"
  ami = "ami-04f9a173520f395dd"
  tags = {
    Name = "worker-1"
    Project = "DevOps Challenge"
  }
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.k3s_subnet[0].id}"
  vpc_security_group_ids = ["${aws_security_group.k3s_worker_sg.id}"]
}

resource "aws_instance" "worker-2" {
  
  instance_type = "t3.micro"
  ami = "ami-04f9a173520f395dd"
  tags = {
    Name = "worker-2"
    Project = "DevOps Challenge"
  }
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.k3s_subnet[0].id}"
  vpc_security_group_ids = ["${aws_security_group.k3s_worker_sg.id}"]
}

output "master_address" {
  value = aws_instance.master.public_ip
}

output "worker-1_address" {
  value = aws_instance.worker-1.public_ip
}

output "worker-2_address" {
  value = aws_instance.worker-2.public_ip
}