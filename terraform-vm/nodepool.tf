#additinal node pool   for gke  cluster

# resource "google_container_node_pool" "extra-pool" {
#   name               = "ritesh-demo2"
#   zone               = "us-east1-a"
#   cluster            = "${google_container_cluster.gke-cluster.name}"
#   initial_node_count = 3
# }