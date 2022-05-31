provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

data "google_client_config" "provider" {}

data "google_container_cluster" "primary" {
    name     = "${var.project}"
    location = var.zone
}

provider "helm" {
  kubernetes {
  host  = "https://${data.google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
    )
  }
}
resource "google_service_account" "service_account_eso" {
  account_id   = "eso-credentials"
  display_name = "ESO Service Account"
}
