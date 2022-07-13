resource "helm_release" "vault-release" {
  name = "vault"
  repository = var.vault-helm-repo
  chart      = var.vault-helm-chart
  namespace  = var.vault-namespace
  create_namespace = true
  set {
    name = "dev.enabled"
    value = "true"
  }
}
