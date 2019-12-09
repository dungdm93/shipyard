Data stacks
===========

:boom: :boom: :boom: **WIP**: New warehouse stack base on Kubernetes :boom: :boom: :boom:

## Structure
```
.
├── docker
│   └── <images>
├── kubernetes
│   └── <components>
├── terraform
│   └── data-warehouse
├── .editorconfig
├── .gitignore
└── README.md
```

## Components
* [x] cert-manager
* [x] nginx-ingress
* [ ] Ceph
* [ ] PostgreSQL
* [ ] Cassandra
* [ ] Keycloak
* [ ] Vault
* [ ] Observability stack
  * [x] Grafana
  * [x] Prometheus
  * [ ] FluentBit
  * [x] Loki
  * [ ] Jaeger
* [x] JupyterHub
* [ ] Airflow
* [ ] Kafka
* [ ] ClickHouse
* [x] Elastic stack
  * [x] ElasticSearch
  * [x] Kibana
