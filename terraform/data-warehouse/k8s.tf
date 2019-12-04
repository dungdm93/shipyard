resource "google_container_cluster" "teko-warehouse" {
  name     = "teko-warehouse"
  location = "${var.region}-a"

  network = google_compute_network.teko-warehouse-net.self_link
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.96.0.0/14"
    services_ipv4_cidr_block = "10.94.0.0/18"
  }
  network_policy {
    enabled = true
  }
  # workload_identity_config {
  #   identity_namespace = "${data.google_project.project.project_id}.svc.id.goog"
  # }
  # pod_security_policy_config {
  #   enabled = true
  # }

  logging_service    = "none"
  monitoring_service = "none"

  addons_config {
    http_load_balancing {
      disabled = true
    }

    # horizontal_pod_autoscaling {
    #   disabled = false
    # }
  }
  # vertical_pod_autoscaling {
  #   enabled = true
  # }
}

resource "google_container_node_pool" "teko-warehouse-storage" {
  name       = "storage"
  cluster    = google_container_cluster.teko-warehouse.name
  node_count = 3

  node_config {
    preemptible  = false
    machine_type = "n1-standard-8"
  }

  # TODO: labels & tain
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
