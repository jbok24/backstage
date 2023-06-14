provider "google" {
  access_token = data.vault_generic_secret.gcp.data["token"]
  project      = "atyeti-backstage"
}

provider "google-beta" {
  access_token = data.vault_generic_secret.gcp.data["token"]
  project      = "atyeti-backstage"

}

provider "vault" {
  address   = "https://aws-us-east-2-public-vault-2d885140.db732eea.z1.hashicorp.cloud:8200"
  namespace = "admin"
}
