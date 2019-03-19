# Credentials for creating kubernetes cluster on GKE
# This is the simplest kubernetes cluster on google kubernetes engine
provider "google" {
  credentials = "${file("../cred/project.json")}"
  project     = "learned-pottery-234003"
  region      = "us-east1"
}

# Primasry (Master node)
resource "google_container_cluster" "primary" {
  name                     = "demo-cluster"
  zone                     = "us-east1-b"
  remove_default_node_pool = true

  node_pool {
    name = "default-pool"
  }
}

# Worker Nodes
resource "google_container_node_pool" "primary_pool" {
  name       = "primary-pool"
  cluster    = "${google_container_cluster.primary.name}"
  zone       = "us-east1-b"
  node_count = "2"

  # Node type 
  node_config {
    machine_type = "n1-standard-1"
  }

  # Auto Scaling
  autoscaling {
    min_node_count = 2
    max_node_count = 5
  }

  # Cluster Management
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
