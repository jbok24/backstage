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

#POSTGRE Persistant Volume

/*
# kubernetes/postgres-storage.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgres-storage
  namespace: backstage
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 2G
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: '/mnt/data'
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-storage-claim
  namespace: backstage
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2G
*/

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

# kubernetes/postgres.yaml
/*apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
  namespace: backstage
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:13.2-alpine
          imagePullPolicy: 'IfNotPresent'
          ports:
            - containerPort: 5432
          envFrom:
            - secretRef:
                name: postgres-secrets
          volumeMounts:
            - mountPath: /var/lib/postgresql/data
              name: postgresdb
      volumes:
        - name: postgresdb
          persistentVolumeClaim:
            claimName: postgres-storage-claim */
    
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
