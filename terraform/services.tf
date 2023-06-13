resource "google_project_service" "services" {
  for_each = toset([
    "artifactregistry",
    "cloudresourcemanager",
    "iam",
  ])

  service = "${each.key}.googleapis.com"
}
