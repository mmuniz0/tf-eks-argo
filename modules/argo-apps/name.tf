# resource "kubernetes_manifest" "argocd_app_api" {
#   #yaml_body = file("../../argo-manifests/api/${var.branch}/api.yaml")
#   manifest = yamldecode(file("./argo-manifests/api/${var.branch}/api.yaml"))
# }

# resource "kubernetes_manifest" "argocd_app_static" {
#   #yaml_body = file("../../argo-manifests/static/${var.branch}/static.yaml")
#   manifest = yamldecode(file("./argo-manifests/api/${var.branch}/api.yaml"))
# }
# provider "kubectl" {}

# resource "kubectl_manifest" "argo_apps" {
#   manifest_dir = "./argo-manifests/api/${var.branch}/"
#   kubeconfig   = local_file.kubeconfig_file.filename
#   wait_timeout = "600s"  # Set a wait timeout for the resource to apply
# }
