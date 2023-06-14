resource "google_service_account" "service_account" {
  account_id = "github-actions"
  project    = "atyeti-backstage"
}

resource "google_project_iam_member" "project" {
  project = "atyeti-backstage"
  role    = "roles/artifactregistry.writer"
  member  = google_service_account.service_account.member
}
