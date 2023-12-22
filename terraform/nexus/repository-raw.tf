locals {
  raw_repos = {
    "github.com" = {
      remote_url = "https://github.com"
    }
    "grafana.com" = {
      remote_url = "https://grafana.com"
    }
  }
}

resource "nexus_repository_raw_proxy" "raw-proxy" {
  for_each = local.raw_repos

  name   = "raw-proxy_${each.key}"
  online = true

  proxy {
    remote_url = each.value.remote_url
  }

  http_client {
    blocked    = false
    auto_block = true
  }

  negative_cache {
    enabled = true
  }

  storage {
    blob_store_name = nexus_blobstore_s3.minio.name
  }

  cleanup {
    policy_names = ["default"]
  }
}
