
resource "google_artifact_registry_repository" "eso" {
  provider = google-beta

  location = var.region
  repository_id = "eso"
  description = "repository for eso related images"
  format = "DOCKER"
}
