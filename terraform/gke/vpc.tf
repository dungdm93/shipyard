resource "google_compute_network" "teko-warehouse-net" {
  name                    = "teko-warehouse-net"
  auto_create_subnetworks = true
  routing_mode            = "REGIONAL"
}

resource "google_compute_address" "teko-warehouse-gw-ip" {
  name   = "teko-warehouse-gw-ip"
  region = var.region
}

resource "google_compute_address" "teko-warehouse-nat-ip" {
  name   = "teko-warehouse-nat-ip"
  region = var.region
}

resource "google_compute_router" "teko-warehouse-router" {
  name    = "teko-warehouse-router"
  network = google_compute_network.teko-warehouse-net.name
  region  = var.region
}

resource "google_compute_router_nat" "teko-warehouse-nat" {
  name                               = "teko-warehouse-nat"
  router                             = google_compute_router.teko-warehouse-router.name
  region                             = var.region
  min_ports_per_vm                   = 64
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.teko-warehouse-nat-ip.self_link]

  log_config {
    enable = false
    filter = "ALL"
  }
}

# Other solution: Using ConfigConnector
# https://cloud.google.com/config-connector/docs/
resource "google_compute_firewall" "teko-warehouse-cert-manager" {
  name    = "teko-warehouse-cert-manager"
  network = google_compute_network.teko-warehouse-net.name

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = [google_container_cluster.teko-warehouse.private_cluster_config[0].master_ipv4_cidr_block]
  target_tags   = ["teko-warehouse"]
}
