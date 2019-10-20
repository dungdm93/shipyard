<div align="center">
<img src="https://s3.amazonaws.com/hashicorp-marketing-web-assets/brand/Vault_PrimaryLogo_FullColor.HkwAATB6e.svg"
    alt="vaults logo" align="middle" height="100" hspace="15"/>
<!-- ref: https://www.hashicorp.com/brand -->
<img src="https://github.com/banzaicloud/bank-vaults/raw/0.5.0/docs/images/logo.png"
    alt="bank-vaults logo" align="middle" height="128" hspace="15"/>
</div>

`bank-vaults`
==============
**Vault** by HashiCorp manage secrets and protect sensitive data.

**bank-vaults** by BanzaiCloud

## 1. Deployment
### 1.1 Installation `Vault Operator`
```bash
helm repo add banzaicloud https://kubernetes-charts.banzaicloud.com
helm repo update

helm install banzaicloud/vault-operator \
    --name=bank-vault-operator \
    --namespace=bank-vault \
    --values=operator/values.yaml
```

### 1.2 Installation `Vault` instance
