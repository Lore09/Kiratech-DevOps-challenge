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

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

  ingress {
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
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
# Kubernetes api
resource "aws_security_group_rule" "Allow_from_worker_to_master_kubernetes_api" {
  type        = "ingress"
  from_port   = 6443
  to_port     = 6443
  protocol    = "tcp"
  security_group_id = aws_security_group.k3s_master_sg.id
  source_security_group_id = aws_security_group.k3s_worker_sg.id
} 

resource "aws_security_group_rule" "Allow_from_worker_to_master_kubelet_metrics" {
  type        = "ingress"
  from_port   = 10250
  to_port     = 10250
  protocol    = "tcp"
  security_group_id = aws_security_group.k3s_master_sg.id
  source_security_group_id = aws_security_group.k3s_worker_sg.id
}

resource "aws_security_group_rule" "Allow_ping_from_worker_to_masters" {
  type        = "ingress"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  security_group_id = aws_security_group.k3s_master_sg.id
  source_security_group_id = aws_security_group.k3s_worker_sg.id
}

resource "aws_security_group_rule" "Allow_ping_from_master_to_workers" {
  type        = "ingress"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  security_group_id = aws_security_group.k3s_worker_sg.id
  source_security_group_id = aws_security_group.k3s_master_sg.id
}