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

#tfsec:ignore:aws-eks-enable-control-plane-logging
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
      # create_launch_template = false
      # launch_template_name   = "ltn"
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
  # Users should pin the version to the latest available release
  # tflint-ignore: terraform_module_pinned_source
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  eks_cluster_id        = module.eks.cluster_name
  eks_cluster_endpoint  = module.eks.cluster_endpoint
  eks_cluster_version   = module.eks.cluster_version
  eks_oidc_provider     = module.eks.oidc_provider
  eks_oidc_provider_arn = module.eks.oidc_provider_arn

  enable_argocd = true
  # # This example shows how to set default ArgoCD Admin Password using SecretsManager with Helm Chart set_sensitive values.
  # argocd_helm_config = {
  #   set_sensitive = [
  #     {
  #       name  = "configs.secret.argocdServerAdminPassword"
  #       value = bcrypt_hash.argo.id
  #     }
  #   ]
  # }

  argocd_manage_add_ons = false # Indicates that ArgoCD is responsible for managing/deploying add-ons
  argocd_applications = {
    # addons = {
    #   path               = "chart"
    #   repo_url           = "https://github.com/aws-samples/eks-blueprints-add-ons.git"
    #   add_on_application = true
    # }
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

#---------------------------------------------------------------
# ArgoCD Admin Password credentials with Secrets Manager
# Login to AWS Secrets manager with the same role as Terraform to extract the ArgoCD admin password with the secret name as "argocd"
#---------------------------------------------------------------
# resource "random_password" "argocd" {
#   length           = 16
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }

# Argo requires the password to be bcrypt, we use custom provider of bcrypt,
# as the default bcrypt function generates diff for each terraform plan
# resource "bcrypt_hash" "argo" {
#   cleartext = random_password.argocd.result
# }

#tfsec:ignore:aws-ssm-secret-use-customer-key
# resource "aws_secretsmanager_secret" "argocd" {
#   name                    = "argocd"
#   recovery_window_in_days = 0 # Set to zero for this example to force delete during Terraform destroy
# }

# resource "aws_secretsmanager_secret_version" "argocd" {
#   secret_id     = aws_secretsmanager_secret.argocd.id
#   secret_string = random_password.argocd.result
# }

################################################################################
# Supporting Resources
################################################################################
