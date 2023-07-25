data "aws_availability_zones" "available" {}

module "eks" {
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

module "eks_blueprints_addons" {
  # Users should pin the version to the latest available release
  # tflint-ignore: terraform_module_pinned_source
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.32.1"

  eks_cluster_id        = module.eks.cluster_id
  eks_cluster_endpoint  = module.eks.cluster_endpoint
  eks_cluster_version   = module.eks.cluster_version
  # eks_oidc_provider     = module.eks.oidc_provider
  # eks_oidc_provider_arn = module.eks.oidc_provider_arn
  enable_argocd = true
  argocd_helm_config = {
    name             = "argo-cd"
    chart            = "argo-cd"
    repository       = "https://argoproj.github.io/argo-helm"
    version          = "5.41.1"
    namespace        = "argocd"
    timeout          = "1200"
    create_namespace = true
    #values = [templatefile("${path.module}/argocd-values.yaml", {})]
  }

  argocd_applications = {
    workloads = {
      name = "api-${terraform.workspace}"
      repository = "https://github.com/mmuniz0/tf-eks-argo.git"
      path = "/argo-manifest/app-of-apps/${var.branch}"
    }
  }
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

