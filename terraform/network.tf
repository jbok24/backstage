module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0"

  mtu              = 1500
  network_name     = "backstage"
  project_id       = local.project
  subnets = [
        {
            subnet_name           = local.region
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = local.region
        },
    ]

    secondary_ranges = {
        "${local.region}" = [
            {
                range_name    = "${local.region}-pods"
                ip_cidr_range = "10.10.11.0/24"
            },
            {
                range_name    = "${local.region}-services"
                ip_cidr_range = "10.10.12.0/24"
            },
        ]
    }
}
