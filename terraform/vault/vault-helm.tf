resource "helm_release" "vault-release" {
  name = "vault"
  namespace  = var.vault-namespace
  create_namespace = true
  repository = var.vault-helm-repo
  chart      = var.vault-helm-chart
  set {
    name  = "server.ha.enabled"
    value = "true"
  }
  set {
    name  = "server.ha.raft.enabled"
    value = "true"
  }
}
