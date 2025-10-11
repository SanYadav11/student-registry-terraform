data "google_project" "project" {
  project_id = var.project_id
}

# Cloud Build service account
locals {
  cloudbuild_sa = "${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# Give Cloud Build permissions to write images to Artifact Registry
resource "google_project_iam_member" "cloudbuild_artifactwriter" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${local.cloudbuild_sa}"
}

# Give Cloud Build ability to get-credentials / deploy to GKE
resource "google_project_iam_member" "cloudbuild_gke_deployer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${local.cloudbuild_sa}"
}

# Often you also need these for deployments (if using kubectl with cluster-admin ops)
resource "google_project_iam_member" "cloudbuild_k8s_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${local.cloudbuild_sa}"
}
