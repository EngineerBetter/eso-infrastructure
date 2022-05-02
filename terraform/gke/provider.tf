provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google_beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

data "google_client_config" "provider" {}