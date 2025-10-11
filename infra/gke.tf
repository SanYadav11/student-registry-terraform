resource "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  location = var.zone
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  # optional: enable basic auth/kubelet certs off for security in production
  remove_default_node_pool = false
  # For production consider using node_pools + autopilot / private cluster
}
