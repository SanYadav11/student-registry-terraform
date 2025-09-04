output "cluster_name"   { value = google_container_cluster.gke.name }
output "endpoint"       { value = google_container_cluster.gke.endpoint }
output "service_ip"     { value = kubernetes_service.app_svc.status[0].load_balancer[0].ingress[0].ip }
output "image_deployed" { value = local.image_ref }
