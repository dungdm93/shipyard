locals {
  k8s_cluster = [
    kit106,
    kitlab,
  ]
  cluster_mesh = {
    kit106 = "172.16.0.1"
    kitlab = "172.16.0.2"
  }

  services = {
    "infradb"     = "172.16.10.1"
    "infradb.lab" = "172.16.10.2"

    "*.lab" = "172.16.10.3"

    "s3"            = "192.168.0.1"
    "loki"          = "192.168.0.2"
    "mimir"         = "192.168.0.3"
    "tempo"         = "192.168.0.4"
    "elasticsearch" = "192.168.0.5"
  }
}

resource "cloudflare_record" "k8s_gw" {
  zone_id = cloudflare_zone.dungdm93_me.id
  name    = "k8s-gw"
  type    = "A"
  value   = "172.16.56.153"
  proxied = false
}

resource "cloudflare_record" "k8s_cluster" {
  for_each = local.k8s_cluster

  zone_id = cloudflare_zone.dungdm93_me.id
  name    = "${each.key}.k8s"
  type    = "CNAME"
  value   = "k8s-gw.dungdm93.me"
  proxied = false
}

resource "cloudflare_record" "cluster_mesh" {
  for_each = local.cluster_mesh

  zone_id = cloudflare_zone.dungdm93_me.id
  name    = "${each.key}.cluster"
  type    = "A"
  value   = each.value
  proxied = false
}

resource "cloudflare_record" "services" {
  for_each = local.services

  zone_id = cloudflare_zone.dungdm93_me.id
  name    = each.key
  type    = "A"
  value   = each.value
  proxied = false
}

resource "cloudflare_record" "iam" {
  zone_id = cloudflare_zone.dungdm93_me.id
  name    = "iam"
  type    = "CNAME"
  value   = "google.com" # dummy domain
  proxied = false
}
