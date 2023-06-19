resource "kubernetes_namespace" "backstage" {
  metadata {
    name = "backstage"
  }
}

resource "kubernetes_secret" "postgres-secrets" {
  metadata {
    name = "postgres-secrets"
    namespace = "backstage"
  }

  data = {
  POSTGRES_USER: "YmFja3N0YWdl"
  POSTGRES_PASSWORD: "aHVudGVyMg=="
  }

  type = "Opaque"
}


# kubernetes/postgres-service.yaml
#apiVersion: v1
#kind: Service
#metadata:
  #name: postgres
  #namespace: backstage
#spec:
  #selector:
    #app: postgres
  #ports:
   #- port: 5432
