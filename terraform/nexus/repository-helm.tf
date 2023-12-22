locals {
  helm_repos = {
    aerospike            = "https://aerospike.github.io/aerospike-kubernetes"
    akhq                 = "https://akhq.io"
    bitnami              = "https://charts.bitnami.com/bitnami"
    calico               = "https://docs.projectcalico.org/charts"
    center               = "https://repo.chartcenter.io"
    ceph-csi             = "https://ceph.github.io/csi-charts"
    cilium               = "https://helm.cilium.io"
    confluentinc         = "https://confluentinc.github.io/cp-helm-charts"
    coredns              = "https://coredns.github.io/helm"
    datahub              = "https://helm.datahubproject.io"
    deliveryhero         = "https://charts.deliveryhero.io"
    elastic              = "https://helm.elastic.co"
    grafana              = "https://grafana.github.io/helm-charts"
    hashicorp            = "https://helm.releases.hashicorp.com"
    ingress-nginx        = "https://kubernetes.github.io/ingress-nginx"
    jetstack             = "https://charts.jetstack.io"
    jupyterhub           = "https://jupyterhub.github.io/helm-chart"
    metallb              = "https://metallb.github.io/metallb"
    metrics-server       = "https://kubernetes-sigs.github.io/metrics-server"
    piraeus              = "https://piraeus.io/helm-charts"
    prometheus-community = "https://prometheus-community.github.io/helm-charts"
    rook                 = "https://charts.rook.io/release"
    scylla               = "https://scylla-operator-charts.storage.googleapis.com/stable"
    spark-operator       = "https://googlecloudplatform.github.io/spark-on-k8s-operator"
    strimzi              = "https://strimzi.io/charts"
    teko                 = "https://hub.teko.vn/chartrepo/library"
    topolvm              = "https://topolvm.github.io/topolvm"
    longhorn             = "https://charts.longhorn.io"
  }
}

resource "nexus_repository_helm_proxy" "helm-proxy" {
  for_each = local.helm_repos

  name   = "helm-proxy_${each.key}"
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
