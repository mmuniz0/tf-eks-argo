variable "app" {
  description = "ID of the VPC to associate with the EKS cluster"
  type        = string
}

variable "argo-domain" {
  description = "Argocd domain"
  type        = string
}
