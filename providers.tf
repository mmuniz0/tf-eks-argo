terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
    bcrypt = {
      source  = "viktorradnai/bcrypt"
      version = ">= 0.1.2"
    }
  }

  # ##  Used for end-to-end testing on project; update to suit your needs
  # backend "s3" {
  #   bucket = "terraform-ssp-github-actions-state"
  #   region = "us-west-2"
  #   key    = "e2e/argocd/terraform.tfstate"
  # }
}

provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = module.eks.eks_host
  cluster_ca_certificate = module.eks.eks_ca_certificate

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.eks_cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.eks_host
    cluster_ca_certificate = module.eks.eks_ca_certificate

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.eks_cluster_name]
    }
  }
}

data "aws_availability_zones" "available" {}

provider "bcrypt" {}

locals {
  region = "us-east-1"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  }

