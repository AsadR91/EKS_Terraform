output "cluster_id" {
  value = aws_eks_cluster.main.id
}

output "node_group_id" {
  value = aws_eks_node_group.main.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.main[*].id
}variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to use for instances"
  type        = string
  default     = "Project-key"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "Number of subnets to create"
  type        = number
  default     = 2
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t2.medium"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 3
}
