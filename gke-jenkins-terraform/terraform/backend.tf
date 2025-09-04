terraform {
  backend "gcs" {
    bucket = "tf-state-YOUR_PROJECT_ID"
    prefix = "gke-iac"
  }
}
