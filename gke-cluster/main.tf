provider "google" {
  credentials = "${file("./credential/account.json")}"
  project     = "shining-lamp-214204"
  region      = "asia-southeast1"
}

# Create GKE Cluster
resource "google_container_cluster" "gke-cluster" {
  name               = "gke-cluster"
  network            = "default"
  zone               = "asia-southeast1-a"
  initial_node_count = 2
  remove_default_node_pool = true
}

# Add node pool with autoscaling 2 to 3
resource "google_container_node_pool" "node-pool" {
  name               = "node-pool"
  zone               = "asia-southeast1-a"
  cluster            = "${google_container_cluster.gke-cluster.name}"
  initial_node_count = 2
  autoscaling {
    min_node_count = 2
    max_node_count = 3
  }
}