locals {
  conda_repos = {
    "repo.anaconda.com"  = "https://repo.anaconda.com"
    "conda.anaconda.org" = "https://conda.anaconda.org"
  }
}

resource "nexus_repository_conda_proxy" "conda-proxy" {
  for_each = local.conda_repos

  name   = "conda-proxy_${each.key}"
  online = true

  proxy {
    remote_url = each.value
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
