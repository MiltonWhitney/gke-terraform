output "cluster_name" {
  value = google_container_cluster.single_node_gke.name
}

output "endpoint" {
  value = google_container_cluster.single_node_gke.endpoint
}

output "location" {
  value = google_container_cluster.single_node_gke.location
}

