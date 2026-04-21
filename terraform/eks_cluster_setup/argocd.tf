resource "helm_release" "argocd" {
  repository = "oci://ghcr.io/argoproj/argo-helm"
  chart      = "argo-cd"
  #version    = "5.24.1"

  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  set = [{
    name  = "server.service.type"
    value = "LoadBalancer"
  }]
  depends_on = [module.eks]
}
