variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "branch" {
  description = "Argocd manifest branch"
  type        = string
}
variable "vpc_cidr" {
  description = "cidr of the VPC to associate with the EKS cluster"
  type        = string
}

