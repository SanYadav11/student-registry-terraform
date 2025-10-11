terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Enable required APIs
resource "google_project_service" "enable_apis" {
  for_each = toset([
    "container.googleapis.com",         # GKE
    "cloudbuild.googleapis.com",        # Cloud Build
    "artifactregistry.googleapis.com",  # Artifact Registry
    "iam.googleapis.com",               # IAM
    "cloudresourcemanager.googleapis.com"
  ])
  service = each.key
}
