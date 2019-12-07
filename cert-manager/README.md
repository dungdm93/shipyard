<img src="https://github.com/jetstack/cert-manager/raw/master/logo/logo.svg?sanitize=true"
    alt="cert-manager logo"
    align="right" height="128"/>

`cert-manager`
==============
**cert-manager** is a native Kubernetes certificate management controller. It can help with issuing certificates from a variety of sources, such as [Let’s Encrypt](https://letsencrypt.org/), [HashiCorp Vault](https://vaultproject.io/), [Venafi](https://venafi.com/), a simple signing keypair, or self signed.

## 1. Deployment
### 1.1. Info
* Kubernetes: v1.13+
* Helm: v3.x
* cert-manager: v0.12
  + Helm chart: v0.12+

### 1.2 Installation
```bash
# Install the CustomResourceDefinition resources separately
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml

# Create the namespace for cert-manager
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/01-namespace.yaml

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install the cert-manager Helm chart
helm upgrade --install \
    cert-manager jetstack/cert-manager \
  --namespace=cert-manager \
  --version=v0.12.0 \
  --values=values.yaml
```

* [ref](https://docs.cert-manager.io/en/latest/getting-started/install/kubernetes.html#steps)

## 2. Usage
### 2.1 Create Issuer
```bash
kubectl apply -f issuers/letsencrypt.yaml
```

* ref: [Supported issuer types](https://docs.cert-manager.io/en/latest/tasks/issuers/index.html#supported-issuer-types)

### 2.2 Issuing Certificates
Certificates can be issued
* *manually* via `Certificate` resource <sup>[(e.g.)](examples/certificate.yaml)</sup> or
* *automatically* for `Ingress` resources <sup>[(e.g.)](examples/ingress.yaml)</sup>

## 3. References
* cert-manager [repo](https://github.com/jetstack/cert-manager) | [docs](https://docs.cert-manager.io)
