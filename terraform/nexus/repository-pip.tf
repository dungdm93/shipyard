locals {
  pip_repos = {
    "pypi" = "https://pypi.org"
  }
}

resource "nexus_repository_pypi_proxy" "pip-proxy" {
  for_each = local.pip_repos

  name   = "pip-proxy_${each.key}"
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
