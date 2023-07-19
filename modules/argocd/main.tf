# ArgoCD Helm Chart
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace  = "argocd"

  set {
    name  = "server.ingress.enabled"
    value = "true"
  }
  set {
    name  = "server.ingress.hosts[0].name"
    value = "argocd.example.com" # Replace with your domain
  }
  set {
    name  = "server.extraArgs[0]"
    value = "--insecure" # Only for demo
  }
}

resource "kubernetes_manifest" "argocd_app_api" {
  yaml_body = file("../../argo-manifests/api/${var.branch}/api.yaml")
}

resource "kubernetes_manifest" "argocd_app_static" {
  yaml_body = file("../../argo-manifests/static/${var.branch}/static.yaml")
}

# # ArgoCD App Sync, using the argocd cli I can re use the code to create the Argo Apps, pther way to do that is creating yaml crds for argocd apps but I'll need one yaml for each app environment
# resource "null_resource" "argocd_app_api" {
#   depends_on = [helm_release.argocd]

#   provisioner "local-exec" {
#     command = "argocd app create ${var.app} --repo https://github.com/your/repo.git --path ${var.app} --revision ${var.branch}  --dest-server https://kubernetes.default.svc --dest-namespace ${var.app}"
#     environment = {
#       KUBECONFIG = "~/.kube/config" 
#     }
#   }
# }

