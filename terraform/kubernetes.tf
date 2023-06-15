# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                = "terraform-google-modules/kubernetes-engine/google"
  project_id            = local.project
  name                  = "backstage"
  region                = local.region
  network               = module.vpc.network_name
  subnetwork            = local.region
  ip_range_pods         = "${local.region}-pods"
  ip_range_services     = "${local.region}-services"
  regional              = true
  grant_registry_access = true
  depends_on = [
    google_project_service.services["artifactregistry"],
    google_project_service.services["compute"],
    google_project_service.services["container"],
  ]

}
