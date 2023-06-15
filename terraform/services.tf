resource "google_project_service" "services" {
  for_each = toset([
    "artifactregistry",
    "cloudresourcemanager",
    "compute",
    "container",
    "iam",
  ])

  service = "${each.key}.googleapis.com"
}
