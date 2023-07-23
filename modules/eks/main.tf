module "eks_cluster" {
  source = "terraform-aws-modules/eks/aws"
  version = "17.4.0" 
  cluster_version = "1.24"

  cluster_name = var.cluster_name
  subnets      = var.subnets_ids

  tags = {
    Environment = terraform.workspace
  }

  vpc_id = var.vpc_id

  worker_groups_launch_template = [
    {
      name                 = "worker-group"
      instance_type        = "m5.large"
      asg_desired_capacity = 2
      additional_security_group_ids = var.sg_id
    }
  ]

  map_roles = [
    {
      rolearn  = aws_iam_role.eks_cluster.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
  ]

}

# Allow EKS nodes to access the LoadBalancer
resource "aws_security_group_rule" "allow_worker_lb_ingress" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] 
  security_group_id = var.sg_id
}


# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  # Assume role policy document
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role Policy for EKS Cluster
resource "aws_iam_role_policy_attachment" "eks_cluster_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}
