terraform {
  cloud {
    organization = "atyeti-inc"

    workspaces {
      name = "backstage"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.61.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.15.0"
    }
  }
}
