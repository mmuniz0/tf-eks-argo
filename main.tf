module "vpc" {
  source = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
 }

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnets_ids  = module.vpc.subnets_ids
  branch       = var.branch
 }

