output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnets_ids" {
  value = module.vpc.private_subnets
}
# output "sg_id" {
#   value = aws_security_group.eks_cluster_sg.id
# }