# production.tfvars

cluster_name = "production-cluster"
vpc_id = "vpc-xxxxx"
argo-domain = "argotest"
branch = "main"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
availability_zone = "us-east-2a"