resource "google_artifact_registry_repository" "backstage" {
  project = "atyeti-backstage"
  location      = local.region
  repository_id = "backstage"
  description   = "Backstage container"
  format        = "DOCKER"
}
