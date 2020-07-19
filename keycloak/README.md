<img src="https://www.keycloak.org/resources/images/keycloak_logo_480x108.png"
    alt="keycloak logo"
    align="right" height="64"/>

`keycloak`
==========
**keycloak** is open source Identity and Access Management (IAM) for modern applications and services.

## 1. Overview
### 1.1 Features
* [ ] [Admin Console Redesign](https://www.keycloak.org/keycloak-community/design/admin-console/#/)
* [ ] [Account Console Redesign](https://marvelapp.com/c90dfi0/screen/59941600)
* [ ] KeyCloak Operator
* [ ] [Keycloak.X](https://github.com/keycloak/keycloak-community/tree/master/design/keycloak.x)
    * [ ] Quarkus
* [x] [Credentials Store - Vault SPI](https://github.com/keycloak/keycloak-community/blob/master/design/secure-credentials-store.md)
    * [docs](https://www.keycloak.org/docs/latest/server_admin/index.html#_vault-administration) | [spi](https://github.com/keycloak/keycloak/blob/master/server-spi/src/main/java/org/keycloak/vault/VaultProvider.java)
* [ ] WebAuthn
* [OpenID Connect Single Logout](https://curity.io/resources/architect/openid-connect/openid-connect-logout/)
    * [ ] Front-channel Logout
        * [spec](https://openid.net/specs/openid-connect-frontchannel-1_0.html) | [JIRA](https://issues.redhat.com/browse/KEYCLOAK-2939)
    * [ ] Back-channel Logout
        * [spec](https://openid.net/specs/openid-connect-backchannel-1_0.html) | [JIRA](https://issues.redhat.com/browse/KEYCLOAK-2940)

### 1.2 References
* [Specifications](https://github.com/keycloak/keycloak-community/tree/master/specifications)

## 2. Deployment
### 2.1. Info
* Kubernetes: v1.13+
* Helm: v3.x
* Keycloak: v8
  + Helm chart: v6.1

### 2.2 Installation
```bash
helm repo add codecentric https://codecentric.github.io/helm-charts
helm repo update

kubectl create ns keycloak

helm upgrade --install \
    keycloak codecentric/keycloak \
  --namespace=keycloak \
  --values=values.yaml
```
