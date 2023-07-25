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
variable "vpc_cidr" {
  description = "cidr of the VPC to associate with the EKS cluster"
  type        = string
}

variable "public_subnet_cidr" {
  description = "public cidr of the subnet to associate with the EKS cluster"
  type        = string
}

variable "private_subnet_cidr" {
  description = "private cidr of the subnet to associate with the EKS cluster"
  type        = string
}

variable "availability_zone" {
  description = "private cidr of the subnet to associate with the EKS cluster"
  type        = string
}

