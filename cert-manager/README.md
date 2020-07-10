<img src="https://github.com/jetstack/cert-manager/raw/master/logo/logo.svg?sanitize=true"
    alt="cert-manager logo"
    align="right" height="128"/>

`cert-manager`
==============
**cert-manager** is a native Kubernetes certificate management controller. It can help with issuing certificates from a variety of sources, such as [Let’s Encrypt](https://letsencrypt.org/), [HashiCorp Vault](https://vaultproject.io/), [Venafi](https://venafi.com/), a simple signing keypair, or self signed.

## 1. Overview
### 1.1 Features
* [x] [JKS and PKCS#12 keystores](https://cert-manager.io/docs/release-notes/release-notes-0.15/#general-availability-of-jks-and-pkcs-12-keystores)
* [x] [kubectl cert-manager CLI plugin](https://cert-manager.io/docs/usage/kubectl-plugin/)
* [ ] [`cert-manager-csi`](https://cert-manager.io/docs/usage/csi/)
* [ ] Private Key rotation

### 1.2 References
* cert-manager [repo](https://github.com/jetstack/cert-manager) | [docs](https://docs.cert-manager.io)

## 2. Deployment
### 2.1. Info
* Kubernetes: v1.13+
* Helm: v3.x
* cert-manager: v0.12
  + Helm chart: v0.12+

### 2.2 Installation
```bash
# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install the cert-manager Helm chart
helm upgrade --install \
    cert-manager jetstack/cert-manager \
  --namespace=cert-manager \
  --version=v0.12.0 \
  --values=values.yaml \
  --create-namespace
```

* [ref](https://docs.cert-manager.io/en/latest/getting-started/install/kubernetes.html#steps)

## 3. Usage
### 3.1 Create Issuer
```bash
kubectl apply -f issuers/letsencrypt.yaml
```

* ref: [Supported issuer types](https://docs.cert-manager.io/en/latest/tasks/issuers/index.html#supported-issuer-types)

### 2.2 Issuing Certificates
Certificates can be issued
* *manually* via `Certificate` resource <sup>[(e.g.)](examples/certificate.yaml)</sup> or
* *automatically* for `Ingress` resources <sup>[(e.g.)](examples/ingress.yaml)</sup>

### 2.3 CA + SelfSigned Certificates
* Uisng `cert-manager` to generate CA Key and self-signed Certificate
    ![ca+selfsigned](./ca+selfsigned.png)

* Using OpenSSL to generate CA Key and self-signed Certificate
    ```bash
    openssl genrsa -out ca.key 2048
    openssl req -new -x509 -key ca.key -out ca.crt -days 3650
    ```
    [ref](https://gist.github.com/Soarez/9688998#ca-key-and-self-signed-certificate)
