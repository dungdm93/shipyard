resource "google_compute_network" "teko-warehouse-net" {
  name                    = "teko-warehouse-net"
  auto_create_subnetworks = true
  routing_mode            = "REGIONAL"
}

resource "google_compute_firewall" "teko-warehouse-firewall-allow-icmp" {
  name     = "${google_compute_network.teko-warehouse-net.name}-allow-icmp"
  network  = google_compute_network.teko-warehouse-net.name
  priority = 65534

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  # targets = all
}

resource "google_compute_firewall" "teko-warehouse-firewall-allow-internal" {
  name     = "${google_compute_network.teko-warehouse-net.name}-allow-internal"
  network  = google_compute_network.teko-warehouse-net.name
  priority = 65534

  # tcp, udp, icmp, esp, ah, sctp
  allow { protocol = "all" }

  source_ranges = ["10.128.0.0/9"]
  # targets = all
}

resource "google_compute_firewall" "teko-warehouse-firewall-allow-rdp" {
  name     = "${google_compute_network.teko-warehouse-net.name}-allow-rdp"
  network  = google_compute_network.teko-warehouse-net.name
  priority = 65534

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  # targets = all
}

resource "google_compute_firewall" "teko-warehouse-firewall-allow-ssh" {
  name     = "${google_compute_network.teko-warehouse-net.name}-allow-ssh"
  network  = google_compute_network.teko-warehouse-net.name
  priority = 65534

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  # targets = all
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
resource "google_compute_firewall" "teko-warehouse-allow-k8s-webhooks" {
  name    = "${google_compute_network.teko-warehouse-net.name}-allow-k8s-webhooks"
  network = google_compute_network.teko-warehouse-net.name

  allow {
    protocol = "tcp"
    # Well-known ports:
    # cert-manager:        6443
    # prometheus-operator: 8443
  }

  source_ranges = [google_container_cluster.teko-warehouse.private_cluster_config[0].master_ipv4_cidr_block]
  target_tags   = ["teko-warehouse"]
}
