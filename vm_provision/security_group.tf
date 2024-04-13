# Security Group for the k3s master nodes
resource "aws_security_group" "k3s_master_sg" {
  vpc_id = aws_vpc.k3s_vpc.id

  # Allow SSH access from trusted IPs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/32", var.trusted_ip)]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k3s_master_sg"
  }
}

# Security Group for the k3s worker nodes
resource "aws_security_group" "k3s_worker_sg" {
  vpc_id = aws_vpc.k3s_vpc.id

  # Allow outgoing traffic to all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k3s_worker_sg"
  }
}

# Allow traffic from the master to the worker nodes
resource "aws_security_group_rule" "Allow_from_master_to_worker" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  security_group_id = aws_security_group.k3s_worker_sg.id
  source_security_group_id = aws_security_group.k3s_master_sg.id
}

# Allow traffic from the worker to the master nodes
resource "aws_security_group_rule" "Allow_from_worker_to_master" {
  type        = "ingress"
  from_port   = 6443
  to_port     = 6443
  protocol    = "tcp"
  security_group_id = aws_security_group.k3s_master_sg.id
  source_security_group_id = aws_security_group.k3s_worker_sg.id
} 