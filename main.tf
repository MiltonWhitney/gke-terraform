terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_container_cluster" "single_node_gke" {
  name     = "single-node-cluster"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "default-node-pool"
  cluster    = google_container_cluster.single_node_gke.name
  location   = var.zone

  node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
