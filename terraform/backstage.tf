# Creating a namespace
resource "kubernetes_namespace" "backstage" {
  metadata {
    name = "backstage"
  }
}

#POSTGRE SECRET
resource "kubernetes_secret" "postgres-secrets" {
  metadata {
    name = "postgres-secrets"
    namespace = "backstage"
  }

  data = {
  POSTGRES_USER: "YmFja3N0YWdl"
  POSTGRES_PASSWORD: "aHVudGVyMg=="
    POSTGRES_USER     = "YmFja3N0YWdl"
    POSTGRES_PASSWORD = "aHVudGVyMg=="
  }

  type = "Opaque"
}

#POSTGRE Persistant Volume

resource "kubernetes_persistent_volume" "postgres-persistent" {
  metadata {
    name      = "postgres-storage"
  }
  spec {
    storage_class_name = "manual"
    capacity = {
      storage = "2G"
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      host_path {
        path = "/mnt/data"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "postgres-persistent" {
  metadata {
    name = "postgres-storage-claim"
  }
  spec {
    storage_class_name = "manual"
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "2G"
      }
    }
  }
}


# POSTGRE Deployment

    
resource "kubernetes_deployment" "postgres-deployment" {
  metadata {
    name = "postgres"
    namespace = "backstage"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          image = "postgres:13.2-alpine"
          image_pull_policy = "IfNotPresent"
          name  = "postgres"
          port {
            container_port = 5432
          }
          env_from {
            secret_ref {
              name = "postgres-secrets"
            }
          }
          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name = "postgresdb"
          }
        }
        volume {
          name = "postgresdb"
          persistent_volume_claim {
            claim_name = "postgres-storage-claim"
          }
        }
      }
    }
  }
}

# POSTGRE Service


resource "kubernetes_api_service" "postgres-service" {
  metadata {
    name = "postgres-service"
  }
  spec {
     group_priority_minimum = 1
     version = "v1"
     version_priority = 1
     group = ""
  }
}

#Kubernetes deployment

/*resource "kubernetes_deployment" "example" {
  metadata {
    name = "kubernetes"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}*/


