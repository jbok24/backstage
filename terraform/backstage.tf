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
  POSTGRES_USER = "YmFja3N0YWdl"
  POSTGRES_PASSWORD = "aHVudGVyMg=="
  }

  type = "Opaque"
}

resource "kubernetes_api_service" "postgres-service" {
  metadata {
    name = "postgres-service"
    namespace = "backstage"
  }
  spec {
    selector {
      app = "${kubernetes_pod.example.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }
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
