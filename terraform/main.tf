resource "google_service_account" "default" {
  account_id   = "node-pool-eso"
  display_name = "Service account for node pools"
  depends_on = [
    google_project_service.iam
  ]
}

#We need to add service account permissions to ourselves
#terraform resource: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member
#available GKE roles can be found here: https://cloud.google.com/iam/docs/understanding-roles
resource "google_project_iam_member" "cluster-permissions" {
  role    = "roles/container.clusterAdmin"
  member  = var.service_account
  project = var.project
}
resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster-${var.project}"
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  
  network = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  depends_on = [
    google_project_service.container
  ]
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "node-pool-${var.project}"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_compute_network" "vpc" {
  name                    = "${var.project}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

resource "google_project_service" "iam" {
  service = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
  disable_on_destroy = false
}