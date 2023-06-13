resource "google_artifact_registry_repository" "backstage" {
  location      = local.region
  repository_id = "backstage"
  description   = "Backstage container"
  format        = "DOCKER"

  depends_on = [google_project_service.services["artifactregistry"]]
}
