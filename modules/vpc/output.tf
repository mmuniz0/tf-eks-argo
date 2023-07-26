output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnets_ids" {
  value = module.vpc.private_subnets
}
