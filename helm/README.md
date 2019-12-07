<img src="https://github.com/cncf/artwork/raw/master/projects/helm/icon/color/helm-icon-color.svg?sanitize=true"
    alt="helm logo"
    align="right" height="128"/>

`helm`
======
**Helm**: The package manager for Kubernetes

# Helm 2
## 1. Architecture
![Helm Architecture](/helm/res/helm-2-architecture.png)

## 2. Installation
### 2.1. Install `helm` (client-site component)
```bash
curl -L https://git.io/get_helm.sh | bash

### or
# from Snap (Linux)
snap install helm --classic

# from Homebrew (macOS)
brew install kubernetes-helm

# from Chocolatey/Scoop (Windows)
choco install kubernetes-helm
scoop install helm
```

[ref](https://helm.sh/docs/using_helm/#installing-helm)

### 2.2. Install `tiller` (server-site component)
```bash
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:tiller

helm init --service-account tiller
```

# Helm 3
## 1. Installation
```bash
curl -L https://github.com/helm/helm/raw/master/scripts/get-helm-3 | bash

### or
# from Homebrew (macOS)
brew install helm

# from Chocolatey (Windows)
choco install kubernetes-helm
```

ref:
* [Announcing get.helm.sh](https://helm.sh/blog/get-helm-sh/)

## 2. Migration
```bash
rm -rf ~/.helm

helm repo add stable    https://kubernetes-charts.storage.googleapis.com
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
helm repo add local     http://127.0.0.1:8879/charts
```

ref:
* [How to migrate from Helm v2 to Helm v3](https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/)

# References
* Helm [home](https://helm.sh/) | [repo](https://github.com/helm)
* [Helm Hub](https://hub.helm.sh/)
* Helm plugins: [docs](https://helm.sh/docs/plugins/)
  * [s3](https://github.com/hypnoglow/helm-s3)
  * [gcs](https://github.com/hayorov/helm-gcs)
  * [git](https://github.com/aslafy-z/helm-git)
  * [2to3](https://github.com/helm/helm-2to3)
  * [diff](https://github.com/databus23/helm-diff)
