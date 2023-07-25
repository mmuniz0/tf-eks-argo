terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.9.0" # Use the latest version
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.0" # Use the latest version
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.22.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

provider "kubernetes" {
  host                   = module.eks.eks_host
  cluster_ca_certificate = base64decode(module.eks.eks_ca_certificate)

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
    cluster_ca_certificate = base64decode(module.eks.eks_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.eks_cluster_name]
    }
  }
}

