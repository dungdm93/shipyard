<img src="https://static-www.elastic.co/v3/assets/bltefdd0b53724fa2ce/blt6ae3d6980b5fd629/5bbca1d1af3a954c36f95ed3/logo-elastic.svg"
    alt="jaeger logo"
    align="right" height="128"/>
<!-- ref: https://www.elastic.co/brand -->

`elastic-operator`
=================
**elastic-operator** (a.k.a Elastic Cloud on Kubernetes) built on the Kubernetes Operator pattern, our offering extends Kubernetes orchestration capabilities to support the *setup*, and *management* of `Elasticsearch` and `Kibana` on Kubernetes

## 1. Installation
```bash
kubectl apply -f https://download.elastic.co/downloads/eck/1.0.0-beta1/all-in-one.yaml

kubectl apply -f ./elasticsearch.yaml
kubectl apply -f ./kibana.yaml
```

## 2. References
* [Elastic Operator docs](https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html)
* [Elasticsearch Plugins and Integrations](https://www.elastic.co/guide/en/elasticsearch/plugins/7.5/index.html)
