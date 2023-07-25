
output "eks_host" {
  description = "Kubernetes Cluster host"
  value       = module.eks.cluster_endpoint
}

# output "eks_token" {
#   description = "Kubernetes Cluster token"
#   value       = data.aws_eks_cluster_auth.cluster.token
# }

output "eks_ca_certificate" {
  description = "Kubernetes Cluster CA certificate"
  value       = base64decode(module.eks.cluster_certificate_authority_data)
}

output "eks_cluster_name" {
  description = "Kubernetes Cluster host"
  value = var.cluster_name
}