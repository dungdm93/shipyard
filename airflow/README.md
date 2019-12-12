<img src="https://upload.wikimedia.org/wikipedia/commons/d/de/AirflowLogo.png"
    alt="Airflow logo"
    align="right" height="80"/>

`Airflow`
=========
**Airflow** is a platform created by community to programmatically author, schedule and monitor workflows.

## 1. Architecture
### 1.1 Celery Executor
![Airflow CeleryExecutor](https://images.ctfassets.net/be04ylp8y0qc/7jm5tFBkD8LmnQmdmkzvZa/3e17809a19f11ee8efbcc87a0a6b389b/1_avBjYUY6ZtfEyTkk7FI8JQ.png?fm=webp)
* [ref](https://www.sicara.ai/blog/2019-04-08-apache-airflow-celery-workers)

## 2. Deployment
### 2.1. Info
* Kubernetes: v1.14+
* Helm: v3.x
* Airflow: v1.10
  + Helm chart: v5.2

### 2.2 Installation
```bash
helm upgrade --install \
    airflow stable/airflow \
  --namespace=airflow \
  --values=profiles/base.yaml
```
And choose additional values for your environment, e.g:
* Executor: Local | Celery | Kubernetes

## 3. References
