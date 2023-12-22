locals {
  docker_repos = {
    "hub.docker.com" = {
      remote_url = "https://registry-1.docker.io"
      index_type = "HUB"
      index_url  = "https://index.docker.io"
    }
    "hub.teko.vn" = {
      remote_url = "https://hub.teko.vn"
    }
    "k8s.gcr.io" = {
      remote_url = "https://k8s.gcr.io"
    }
    "quay.io" = {
      remote_url = "https://quay.io"
    }
    "gcr.io" = {
      remote_url = "https://gcr.io"
    }
    "ghcr.io" = {
      remote_url = "https://ghcr.io"
    }
    "docker.elastic.co" = {
      remote_url = "https://docker.elastic.co"
    }
  }
}

resource "nexus_repository_docker_group" "docker-group" {
  name   = "docker-group"
  online = true

  group {
    member_names = [
      for repo in nexus_repository_docker_proxy.docker-proxy : repo.name
    ]
  }

  docker {
    # Allow anonymous docker pull
    force_basic_auth = false
    http_port        = 8082
    v1_enabled       = false
  }

  storage {
    blob_store_name = nexus_blobstore_s3.minio.name
  }
}

resource "nexus_repository_docker_proxy" "docker-proxy" {
  for_each = local.docker_repos

  name   = "docker-proxy_${each.key}"
  online = true

  docker {
    # Allow anonymous docker pull
    force_basic_auth = false
    v1_enabled       = false
  }

  docker_proxy {
    index_type = lookup(each.value, "index_type", "REGISTRY")
    index_url  = lookup(each.value, "index_url", each.value.remote_url)
  }

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
