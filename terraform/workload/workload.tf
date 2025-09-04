locals {
  image_ref = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repo}/${var.image}:${var.image_tag}"
}

resource "kubernetes_deployment" "app" {
  metadata {
    name = "myapp"
    labels = { app = "myapp" }
  }
  spec {
    replicas = 2
    selector { match_labels = { app = "myapp" } }
    template {
      metadata { labels = { app = "myapp" } }
      spec {
        container {
          name  = "myapp"
          image = local.image_ref
          port {
            container_port = 9091
          }
          resources {
            requests = { cpu = "250m", memory = "256Mi" }
            limits   = { cpu = "500m", memory = "512Mi" }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app_svc" {
  metadata { name = "myapp-service" }
  spec {
    selector = { app = "myapp" }
    type     = "LoadBalancer"
    port {
      port        = 9091
      target_port = 9091
    }
  }
}
