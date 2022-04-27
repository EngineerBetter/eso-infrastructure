variable "project" {
  type = string
  default = "kubernetes-cluster-eso"
}

variable "service_account" {
  type = string
}
variable "region" {
  type = string
  default = "europe-west2"
}

variable "zone" {
  type = string
  default = "europe-west2-a"
}