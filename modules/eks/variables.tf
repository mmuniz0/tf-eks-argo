# variables.tf

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to associate with the EKS cluster"
  type        = string
}

variable "subnets_ids" {
  description = "ID of the VPC to associate with the EKS cluster"
  type        = list
}
# variable "sg_id" {
#   description = "ID of the VPC to associate with the EKS cluster"
#   type        = string
# }
variable "branch" {
  description = "ID of the VPC to associate with the EKS cluster"
  type        = string
}
