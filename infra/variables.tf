variable "project_id" {
  type = string
  default = "student-registry-kub-jenkins"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "gke_cluster_name" {
  type    = string
  default = "demo-gke-cluster"
}

variable "artifact_repo" {
  type    = string
  default = "springboot-artifacts"
}

variable "github_repo_full_name" {
  type = string
  default = "SanYadav11/student-registry-terraform.git"
}
