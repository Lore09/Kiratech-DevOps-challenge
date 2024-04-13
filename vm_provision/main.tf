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

resource "aws_key_pair" "local_key_pair" {
  key_name = "local_key_pair"
  public_key = file("../env/ssh-key.pub")
}

# Master node
resource "aws_instance" "master" {
  
  instance_type = "t3.micro"
  ami = "ami-04f9a173520f395dd"
  tags = {
    Type = "master"
    Name = "master"
    Project = "DevOps Challenge"
  }
  key_name = aws_key_pair.local_key_pair.key_name

  associate_public_ip_address = true
  subnet_id = "${aws_subnet.k3s_subnet[0].id}"
  vpc_security_group_ids = ["${aws_security_group.k3s_master_sg.id}"]

  user_data = "${file("init-vm")}"
}

# Worker nodes
resource "aws_instance" "worker-1" {
  
  instance_type = "t3.micro"
  ami = "ami-04f9a173520f395dd"
  tags = {
    Type = "worker"
    Name = "worker-1"
    Project = "DevOps Challenge"
  }
  key_name = aws_key_pair.local_key_pair.key_name

  associate_public_ip_address = true
  subnet_id = "${aws_subnet.k3s_subnet[0].id}"
  vpc_security_group_ids = ["${aws_security_group.k3s_worker_sg.id}"]
  
  user_data = "${file("init-vm")}"
}

resource "aws_instance" "worker-2" {
  
  instance_type = "t3.micro"
  ami = "ami-04f9a173520f395dd"
  tags = {
    Type = "worker"
    Name = "worker-2"
    Project = "DevOps Challenge"
  }
  key_name = aws_key_pair.local_key_pair.key_name

  associate_public_ip_address = true
  subnet_id = "${aws_subnet.k3s_subnet[0].id}"
  vpc_security_group_ids = ["${aws_security_group.k3s_worker_sg.id}"]

  user_data = "${file("init-vm")}"
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