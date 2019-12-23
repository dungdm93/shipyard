<img src="https://www.keycloak.org/resources/images/keycloak_logo_480x108.png"
    alt="keycloak logo"
    align="right" height="64"/>

`keycloak`
==========
**keycloak** is open source Identity and Access Management (IAM) for modern applications and services.


## 1. Deployment
### 1.1. Info
* Kubernetes: v1.13+
* Helm: v3.x
* Keycloak: v8
  + Helm chart: v6.1

### 1.2 Installation
```bash
helm repo add codecentric https://codecentric.github.io/helm-charts
helm repo update

kubectl create ns keycloak

helm upgrade --install \
    keycloak codecentric/keycloak \
  --namespace=keycloak \
  --values=values.yaml
```

## 2. References
