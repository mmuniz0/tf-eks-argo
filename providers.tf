

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.59.0" # Use the latest version
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0" # Use the latest version
    }
  }
}

provider "aws" {
  region = "us-east-2" # Replace with your desired AWS region
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" # Replace with your kubeconfig path if needed
  }
}