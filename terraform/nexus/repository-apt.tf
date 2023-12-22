locals {
  apt_distros = {
    ubuntu = [
      "focal", "focal-updates", "focal-backports",    # 20.04
      "bionic", "bionic-updates", "bionic-backports", # 18.04
    ]
    ubuntu_security = [
      "focal-security",
      "bionic-security"
    ]
    debian = [
      "buster", "buster-updates",   # 10
      "stretch", "stretch-updates", # 9
      "jessie", "jessie-updates",   # 8
    ]
    debian_security = [
      "buster/updates",  # 10
      "stretch/updates", # 9
      "jessie/updates",  # 8
    ]
    docker = [
      "focal", "bionic",             # ubuntu
      "buster", "stretch", "jessie", # debian
    ]
    microsoft = ["focal"]
    mongodb   = ["focal"]
  }
  apt_repos = {
    "archive.ubuntu.com" = {
      remote_url    = "http://archive.ubuntu.com/ubuntu/"
      distributions = local.apt_distros["ubuntu"]
    }
    "security.ubuntu.com" = {
      remote_url    = "http://security.ubuntu.com/ubuntu/"
      distributions = local.apt_distros["ubuntu_security"]
    }
    "deb.debian.org" = {
      remote_url    = "http://deb.debian.org/debian"
      distributions = local.apt_distros["debian"]
    }
    "security.debian.org" = {
      remote_url    = "http://security.debian.org/debian-security"
      distributions = local.apt_distros["debian_security"]
    }
    "download.docker.com" = {
      remote_url    = "https://download.docker.com/"
      distributions = local.apt_distros["docker"]
    }
    # https://docs.microsoft.com/sql/linux/sql-server-linux-setup-tools#ubuntu
    "packages.microsoft.com" = {
      remote_url    = "https://packages.microsoft.com/ubuntu/20.04/prod"
      distributions = local.apt_distros["microsoft"]
    }
    "repo.mongodb.org" = {
      remote_url    = "https://repo.mongodb.org/apt/ubuntu"
      distributions = local.apt_distros["mongodb"]
    }
  }
}

resource "nexus_repository_apt_proxy" "apt-proxy" {
  for_each = local.apt_repos

  name         = "apt-proxy_${each.key}"
  online       = true
  distribution = join(" ", each.value.distributions)
  flat         = false

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
