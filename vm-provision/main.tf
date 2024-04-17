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
  
  instance_type = "t3.medium"
  ami = "ami-023adaba598e661ac"
  tags = {
    Group = "server"
    Name = "master"
    Project = "DevOps Challenge"
  }
  key_name = aws_key_pair.local_key_pair.key_name

  associate_public_ip_address = true
  subnet_id = "${aws_subnet.k3s_subnet[0].id}"
  vpc_security_group_ids = ["${aws_security_group.k3s_master_sg.id}"]

  provisioner "file" {
    source      = "../env/ssh-key"
    destination = "/home/ubuntu/.ssh/id_rsa"
  }

  provisioner "file" {
    source      = "../env/ssh-key.pub"
    destination = "/home/ubuntu/.ssh/id_rsa.pub"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("../env/ssh-key")
    host        = self.public_ip
  }

  user_data = "${file("init-master")}"
}

# Worker nodes
resource "aws_instance" "worker-1" {
  
  instance_type = "t3.medium"
  ami = "ami-023adaba598e661ac"
  tags = {
    Group = "agent"
    Name = "worker-1"
    Project = "DevOps Challenge"
  }
  key_name = aws_key_pair.local_key_pair.key_name

  associate_public_ip_address = true
  subnet_id = "${aws_subnet.k3s_subnet[0].id}"
  vpc_security_group_ids = ["${aws_security_group.k3s_worker_sg.id}"]
  
  user_data = "${file("init-worker")}"
}

resource "aws_instance" "worker-2" {
  
  instance_type = "t3.medium"
  ami = "ami-023adaba598e661ac"
  tags = {
    Group = "agent"
    Name = "worker-2"
    Project = "DevOps Challenge"
  }
  key_name = aws_key_pair.local_key_pair.key_name

  associate_public_ip_address = true
  subnet_id = "${aws_subnet.k3s_subnet[0].id}"
  vpc_security_group_ids = ["${aws_security_group.k3s_worker_sg.id}"]

  user_data = "${file("init-worker")}"
}

output "master_public_address" {
  value = aws_instance.master.public_ip
}
output "master_private_address" {
  value = aws_instance.master.private_ip
}

output "worker-1_private_address" {
  value = aws_instance.worker-1.private_ip
}

output "worker-2_private_address" {
  value = aws_instance.worker-2.private_ip
}