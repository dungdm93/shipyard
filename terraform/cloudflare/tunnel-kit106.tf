resource "cloudflare_tunnel" "kit106" {
  account_id = var.cloudflare.account_id
  name       = "kit106.cluster"
  secret     = "AQIDBAUGBwgBAgMEBQYHCAECAwQFBgcIAQIDBAUGBwg="
  config_src = "cloudflare"
}

resource "cloudflare_tunnel_config" "kit106" {
  account_id = var.cloudflare.account_id
  tunnel_id  = cloudflare_tunnel.kit106.id

  config {
    ingress_rule {
      hostname = "vault.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://vault.vault.svc:8200"
    }
    ingress_rule {
      hostname = "keycloak.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://keycloak.keycloak.svc:80"
    }
    ingress_rule {
      hostname = "ceph.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://rook-ceph-mgr-dashboard.rook-ceph.svc:7000"
    }

    ingress_rule {
      hostname = "jupyter.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://jupyterhub-proxy-public.jupyter.svc"
    }
    ingress_rule {
      hostname = "airflow.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://airflow-webserver.airflow.svc:8080"
    }
    ingress_rule {
      hostname = "spark.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://spark-proxy.spark-proxy.svc:18080"
    }

    ingress_rule {
      hostname = "grafana.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://grafana.grafana.svc:80"
    }
    ingress_rule {
      hostname = "harbor.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://harbor.harbor.svc:80"
    }
    ingress_rule {
      hostname = "trino.${cloudflare_zone.dungdm93_me.zone}"
      service  = "https://trino.trino.svc:8443"
      origin_request {
        no_tls_verify = true
      }
    }
    ingress_rule {
      hostname = "databus.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://console.kafka.svc:8080"
    }
    ingress_rule {
      hostname = "datahub.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://datahub-frontend.datahub.svc:9002"
    }
    ingress_rule {
      hostname = "superset.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://superset-webserver.superset.svc:8088"
    }
    ingress_rule {
      hostname = "kibana.${cloudflare_zone.dungdm93_me.zone}"
      service  = "http://kibana.elasticsearch.svc:5601"
    }

    # Catch-all rule
    ingress_rule {
      service = "http_status:404"
    }
  }
}
