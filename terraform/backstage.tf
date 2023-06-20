# Creating a namespace
resource "kubernetes_namespace" "backstage" {
  metadata {
    name = "backstage"
  }
}

#POSTGRE SECRET
resource "kubernetes_secret" "postgres-secrets" {
  metadata {
    name      = "postgres-secrets"
    namespace = "backstage"
  }

  data = {
    POSTGRES_USER     = "YmFja3N0YWdl"
    POSTGRES_PASSWORD = "aHVudGVyMg=="
  }

  type = "Opaque"
}
