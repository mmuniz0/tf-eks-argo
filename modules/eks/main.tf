data "aws_availability_zones" "available" {}
locals {
  name   = terraform.workspace
  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/aws-ia/terraform-aws-eks-blueprints"
  }
}

################################################################################
# Cluster
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  cluster_name                   = var.cluster_name
  cluster_version                = "1.27"
  cluster_endpoint_public_access = true

  # EKS Addons
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnets_ids

  eks_managed_node_groups = {
    initial = {
      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }

  tags = local.tags
}

################################################################################
# EKS Blueprints Addons
################################################################################

module "eks_blueprints_addons" {

  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  eks_cluster_id        = module.eks.cluster_name
  eks_cluster_endpoint  = module.eks.cluster_endpoint
  eks_cluster_version   = module.eks.cluster_version
  eks_oidc_provider     = module.eks.oidc_provider
  eks_oidc_provider_arn = module.eks.oidc_provider_arn

  enable_argocd = true

  argocd_manage_add_ons = false 
  argocd_applications = {
    workloads = {
      path               = "envs/dev"
      repo_url           = "https://github.com/aws-samples/eks-blueprints-workloads.git"
      add_on_application = false
    }
  }

  # Add-ons
  enable_amazon_eks_aws_ebs_csi_driver = false
  enable_aws_load_balancer_controller  = false
  enable_cert_manager                  = false
  enable_karpenter                     = false
  enable_metrics_server                = false
  enable_argo_rollouts                 = false

  tags = local.tags
}
