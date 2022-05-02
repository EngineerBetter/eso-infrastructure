
resource "google_artifact_registry_repository" "eso" {
  provider = google-beta
  project = var.project
  location = var.region
  repository_id = "beach-team-eso"
  description = "repository for eso related images"
  format = "DOCKER"
}
