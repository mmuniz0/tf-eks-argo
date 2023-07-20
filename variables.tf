# variables.tf

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to associate with the EKS cluster"
  type        = string
}

variable "argo-domain" {
  description = "Argocd domain"
  type        = string
}
variable "branch" {
  description = "Argocd manifest branch"
  type        = string
}
