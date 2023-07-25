module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.main-id
  subnets_ids  = module.vpc.subnets_ids
  sg_id        = module.vpc.sg_id
  branch       = var.branch
}

# module "argocd" {
#   source      = "./modules/argocd"
#   argo-domain = var.argo-domain
#   #complete this urgent
# }

# module "argo-apps" {
#   source = "./modules/argo-apps"
#   branch = var.branch
#   #complete this urgent
# }