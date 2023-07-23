module "vpc" {
  source = "./modules/vpc"  

  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone  = "us-west-2a"
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.main-id
  subnets_ids  = module.vpc.subnets_ids
  sg_id        = module.vpc.sg_id
}

module "argocd" {
  source      = "./modules/argocd"
  argo-domain = var.argo-domain
  #complete this urgent
}

module "argo-apps" {
  source = "./modules/argo-apps"
  branch = var.branch
  #complete this urgent
}

# #################################################################################################################################################
# # EKS cluster and node group
# module "eks_cluster" {
#   source = "terraform-aws-modules/eks/aws"
#   version = "17.4.0" 
#   kubernetes_version = "1.21" 

#   cluster_name = var.cluster_name
#   subnets      = [aws_subnet.private.*.id]

#   tags = {
#     Environment = terraform.workspace
#   }

#   vpc_id = var.vpc_id

#   worker_groups_launch_template = [
#     {
#       name                 = "worker-group"
#       instance_type        = "m5.large"
#       asg_desired_capacity = 2
#       additional_security_group_ids = [aws_security_group.eks_cluster.id]
#     }
#   ]

#   map_roles = [
#     {
#       rolearn  = aws_iam_role.eks_cluster.arn
#       username = "system:node:{{EC2PrivateDNSName}}"
#       groups   = ["system:bootstrappers", "system:nodes"]
#     },
#   ]

# }

# # ArgoCD Helm Chart
# resource "helm_release" "argocd" {
#   name       = "argocd"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"

#   namespace  = "argocd"

#   set {
#     name  = "server.ingress.enabled"
#     value = "true"
#   }
#   set {
#     name  = "server.ingress.hosts[0].name"
#     value = "argocd.example.com" # Replace with your domain
#   }
#   set {
#     name  = "server.extraArgs[0]"
#     value = "--insecure" # Only for demo purposes; use TLS certificates for production
#   }
# }


# # ArgoCD App Sync
# resource "null_resource" "argocd_app_api" {
#   depends_on = [helm_release.argocd]

#   provisioner "local-exec" {
#     command = "argocd app create app_api --repo https://github.com/your/repo.git --path static --revision ${var.branch}  --dest-server https://kubernetes.default.svc --dest-namespace api"
#     environment = {
#       KUBECONFIG = "~/.kube/config" 
#     }
#   }
# }

# resource "null_resource" "argocd_app_static" {
#   depends_on = [helm_release.argocd]

#   provisioner "local-exec" {
#     command = "argocd app create app_static --repo https://github.com/your/repo.git --path api --revision ${var.branch} --dest-server https://kubernetes.default.svc --dest-namespace api"
#     environment = {
#       KUBECONFIG = "~/.kube/config" 
#     }
#   }
# }

# # Allow EKS nodes to access the LoadBalancer
# resource "aws_security_group_rule" "allow_worker_lb_ingress" {
#   type        = "ingress"
#   from_port   = 0
#   to_port     = 65535
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"] 
#   security_group_id = aws_security_group.eks_cluster.id
# }