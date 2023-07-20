resource "kubernetes_manifest" "argocd_app_api" {
  yaml_body = file("../../argo-manifests/api/${var.branch}/api.yaml")
}

resource "kubernetes_manifest" "argocd_app_static" {
  yaml_body = file("../../argo-manifests/static/${var.branch}/static.yaml")
}