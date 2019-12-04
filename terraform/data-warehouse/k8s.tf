resource "google_container_cluster" "teko-warehouse" {
  name     = "teko-warehouse"
  location = "asia-southeast1-a"

  network = google_compute_network.k8s-network.self_link
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.28.0.0/14"
    services_ipv4_cidr_block = "10.95.0.0/20"
  }

  logging_service    = "none"
  monitoring_service = "none"

  maintenance_policy {
    daily_maintenance_window {
      start_time = "20:00"
    }
  }
}

resource "google_container_node_pool" "teko-warehouse-storage" {
  name       = "storage"
  cluster    = google_container_cluster.teko-warehouse.name
  node_count = 3

  node_config {
    preemptible  = false
    machine_type = "n1-standard-8"
  }
}

resource "google_container_node_pool" "teko-warehouse-compute" {
  name    = "compute"
  cluster = google_container_cluster.teko-warehouse.name

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  node_config {
    preemptible  = true
    machine_type = "n1-standard-8"
  }
}
