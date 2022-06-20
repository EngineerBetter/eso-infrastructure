variable "project" {
  type = string
  default = "kubernetes-cluster-eso"
}

variable "region" {
  type = string
  default = "europe-west2"
}

variable "zone" {
  type = string
  default = "europe-west2-a"
}
variable "vault-helm-repo" {
  type    = string
  default = "https://helm.releases.hashicorp.com"
}
variable "vault-helm-chart" {
  type    = string
  default = "vault"
}
variable "vault-namespace" {
    type = string
    default = "vault-ns"
}
