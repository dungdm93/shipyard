locals {
  maven_repos = {
    "central"        = "https://repo1.maven.org/maven2/"
    "confluent"      = "https://packages.confluent.io/maven/"
    "spark-packages" = "https://dl.bintray.com/spark-packages/maven/"
  }
}

resource "nexus_repository_maven_proxy" "maven-proxy" {
  for_each = local.maven_repos

  name   = "maven-proxy_${each.key}"
  online = true

  proxy {
    remote_url = each.value
  }

  maven {
    version_policy = "RELEASE"
    layout_policy  = "PERMISSIVE"
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
