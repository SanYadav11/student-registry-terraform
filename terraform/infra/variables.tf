variable "project_id"    { type = string }
variable "region" { 
type = string
default = "us-central1" 
}
variable "cluster_name"  { 
type = string
default = "jenkins-gke-cluster" 
}
variable "repo" {
 type = string
 default = "myrepo"
 }
variable "image"{ 
type = string
default = "myapp" 
}
variable "image_tag" { type = string }
variable "node_count" {
 type = number
default = 2 
}
variable "machine_type"  { 
type = string
 default = "e2-medium"
 }
