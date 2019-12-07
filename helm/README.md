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
## 2. Installation
```bash
curl -L https://github.com/helm/helm/raw/master/scripts/get-helm-3 | bash

### or
# from Homebrew (macOS)
brew install helm

# from Chocolatey (Windows)
choco install kubernetes-helm
```

# References
* Helm [home](https://helm.sh/) | [repo](https://github.com/helm)
* [Helm Hub](https://hub.helm.sh/)
* Helm plugins: [docs](https://helm.sh/docs/plugins/)
  * [s3](https://github.com/hypnoglow/helm-s3)
  * [gcs](https://github.com/hayorov/helm-gcs)
  * [git](https://github.com/aslafy-z/helm-git)
  * [2to3](https://github.com/helm/helm-2to3)
