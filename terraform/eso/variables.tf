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


variable "version_file" {
  type = string
}

variable "image_registry" {
  type = string 
}

variable "helm_charts_dir" {
  type = string
}