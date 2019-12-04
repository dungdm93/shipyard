resource "google_compute_network" "k8s-network" {
  name                    = "k8s-network"
  auto_create_subnetworks = true
  routing_mode            = "REGIONAL"
}

resource "google_compute_address" "teko-warehouse-gw" {
  name   = "teko-warehouse-gw"
  region = "asia-southeast1"
}

resource "google_compute_address" "teko-warehouse-nat" {
  name   = "teko-warehouse-nat"
  region = "asia-southeast1"
}

resource "google_compute_router" "k8s-router-asia-southeast1" {
  name    = "k8s-router-asia-southeast1"
  network = google_compute_network.k8s-network.name
  region  = google_compute_address.teko-warehouse-nat.region
}

resource "google_compute_router_nat" "k8s-nat-asia-southeast1" {
  name                               = "k8s-nat-asia-southeast1"
  router                             = google_compute_router.k8s-router-asia-southeast1.name
  region                             = google_compute_address.teko-warehouse-nat.region
  min_ports_per_vm                   = 64
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.teko-warehouse-nat.self_link]

  log_config {
    enable = false
    filter = "ALL"
  }
}
