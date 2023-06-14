resource "google_service_account" "service_account" {
  account_id = "github-actions"
  project    = "atyeti-backstage"
  project_id = local.project
}

resource "google_project_iam_member" "project" {
  project = "atyeti-backstage"
  project_id = local.project
  role    = "roles/artifactregistry.writer"
  member  = google_service_account.service_account.member
}
