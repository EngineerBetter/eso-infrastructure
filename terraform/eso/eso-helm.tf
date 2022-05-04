resource "helm_release" "external-secrets" {
  name       = "external-secrets"
  chart      = var.helm_charts_dir
  namespace  = "external-secrets"
  create_namespace = true
    set {
    name  = "image.repository"
    value = var.image_registry
  }
    set {
    name  = "webhook.image.repository"
    value = var.image_registry
  }
    set {
    name  = "certController.image.repository"
    value = var.image_registry
  }

    set {
    name  = "image.tag"
    value = file(var.version_file)
  }
    set {
    name  = "webhook.image.tag"
    value = file(var.version_file)
  }
    set {
    name  = "certController.image.tag"
    value = file(var.version_file)
  }
    set {
    name  = "image.pullPolicy"
    value = "Always"
  }
    set {
    name  = "webhook.image.pullPolicy"
    value = "Always"
  }
    set {
    name  = "certController.image.pullPolicy"
    value = "Always"
  }
}
