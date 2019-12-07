<img src="https://grafana.com/static/img/docs/logos/icon_loki.svg"
    alt="loki logo"
    align="right" height="80"/>

`loki`
======
**Loki** is a horizontally-scalable, highly-available, multi-tenant log aggregation system inspired by *Prometheus*. It is designed to be very cost effective and easy to operate. It does not index the contents of the logs, but rather a set of labels for each log stream.

## 1. Architecture
![Loki Architecture](https://grafana.com/static/assets/img/blog/image4.png)
* [ref](https://grafana.com/blog/2018/12/12/loki-prometheus-inspired-open-source-logging-for-cloud-natives/)

## 2. Deployment
### 2.1. Info
* Kubernetes: v1.14+
* Helm: v3.x
* Loki: v1.1
  + Helm chart: v0.20

### 2.2 Installation
```bash
helm repo add loki https://grafana.github.io/loki/charts
helm repo update

helm upgrade --install \
    loki loki/loki \
  --namespace=kube-observability \
  --values=values.yaml
```

## 3. References
* [docs](https://github.com/grafana/loki/tree/master/docs/)
  * [installation](https://github.com/grafana/loki/tree/master/docs/installation/)
* [helm chart](https://github.com/grafana/loki/blob/master/production/helm/)
* Blogs:
  * [Loki’s Path to GA: Docker Logging Driver Plugin & Support for Systemd](https://grafana.com/blog/2019/07/15/lokis-path-to-ga-docker-logging-driver-plugin-support-for-systemd/)
