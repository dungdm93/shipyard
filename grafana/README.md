<img src="https://github.com/grafana/grafana/raw/master/public/img/grafana_icon.svg?sanitize=true"
    alt="grafana logo"
    align="right" height="128"/>

`grafana`
=========
**Grafana** is an open-source, general purpose analytics and monitoring platform. It supports [InfluxDB](https://www.influxdata.com/), [Prometheus](https://prometheus.io/), [AWS CloudWatch](https://aws.amazon.com/cloudwatch/), [GCP Stackdriver](https://cloud.google.com/stackdriver/)... as datasources, with variety of dashboard panels.

## 1. Deployment
### 1.1. Info
* Kubernetes: v1.13+
* Helm: v3.x
* Grafana: v6.5
  + Helm chart: v4.1

### 1.2 Installation
```bash
helm upgrade --install \
    griffin stable/grafana \
  --namespace=kube-observability \
  --values=values.yaml
```

## 2. Well-known dashboards
* [`kubernetes-monitoring/kubernetes-mixin`](https://github.com/kubernetes-monitoring/kubernetes-mixin/): Kubernetes Infra dashboards
* [`povilasv/kubernetes-grafana-mixin`](https://github.com/povilasv/kubernetes-grafana-mixin): Kubernetes Control Plan dashboards. [ref](https://povilasv.me/grafana-dashboards-for-kubernetes-administrators/)
* [Istio Control Plan dashboards](https://github.com/istio/istio/tree/master/install/kubernetes/helm/istio/charts/grafana/dashboards)
* [`grafana/grafonnet-lib`](https://github.com/grafana/grafonnet-lib)
* [`grafana/jsonnet-libs`](https://github.com/grafana/jsonnet-libs)
  * consul-mixin
  * jaeger-mixin
  * memcached-mixin
* [NGINX Ingress controller](https://grafana.com/grafana/dashboards/9614) | [source](https://github.com/kubernetes/ingress-nginx/tree/master/deploy/grafana/dashboards)
* [Percona dashboards](https://github.com/percona/grafana-dashboards) for MySQL, MongoDB,...
* [`thanos-mixin`](https://github.com/thanos-io/kube-thanos/tree/master/jsonnet/thanos-mixin)
* [`etcd-mixin`](https://github.com/etcd-io/etcd/tree/master/Documentation/etcd-mixin)
----------
* ref: [Everything You Need to Know About Monitoring Mixins](https://grafana.com/blog/2018/09/13/everything-you-need-to-know-about-monitoring-mixins/)
