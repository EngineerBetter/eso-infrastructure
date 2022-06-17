resource "helm_release" "vault" {
  name       = "vault"
  chart      = var.helm_charts_dir
  namespace  = "vault"
  create_namespace = true
}
