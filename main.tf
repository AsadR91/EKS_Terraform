provider "aws" {
  region = var.region
}

locals {
  project_name = "project"
  tags = {
    Name = local.project_name
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${local.project_name}-vpc"
  }
}

resource "aws_subnet" "main" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.project_name}-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.project_name}-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${local.project_name}-route-table"
  }
}

resource "aws_route_table_association" "main" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "cluster" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project_name}-cluster-sg"
  }
}

resource "aws_security_group" "nodes" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project_name}-node-sg"
  }
}

resource "aws_eks_cluster" "main" {
  name     = "${local.project_name}-cluster"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids         = aws_subnet.main[*].id
    security_group_ids = [aws_security_group.cluster.id]
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.project_name}-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = aws_subnet.main[*].id

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.desired_capacity
    min_size     = var.desired_capacity
  }

  instance_types = [var.node_instance_type]

  remote_access {
    ec2_ssh_key = var.ssh_key_name
    source_security_group_ids = [aws_security_group.nodes.id]
  }
}

resource "aws_iam_role" "eks" {
  name = "${local.project_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "node" {
  name = "${local.project_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_worker" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_cni" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_registry" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
