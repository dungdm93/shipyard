<div>
    <img src="https://avatars1.githubusercontent.com/u/22800682?s=200&v=4"
        alt="JupyterLab logo" height="80" align="right"/>
    <img src="https://jupyter.org/assets/hublogo.svg"
        alt="JupyterHub logo" height="80" align="right"/>
    <img src="https://jupyter.org/assets/main-logo.svg"
        alt="Jupyter logo" height="80" align="right"/>
</div>

`Jupyter`
=========
* Project **Jupyter** exists to develop open-source software, open-standards, and services for interactive computing across dozens of programming languages.
* **JupyterLab**: The Next Generation UI for Project Jupyter
* **JupyterHub**: A multi-user version of the notebook designed for companies, classrooms and research labs.

## 1. Architecture
![JupyterHub Architecture](https://jupyterhub.readthedocs.io/en/stable/_images/jhub-fluxogram.jpeg)

## 2. Deployment
### 2.1. Info
* Kubernetes: v1.14+
* Helm: v3.x
* JupyterHub: v1.0
  + Helm chart: v0.8.2

### 2.2 Installation
```bash
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

kubectl create ns jupyter

helm upgrade --install \
    jove jupyterhub/jupyterhub \
  --namespace=jupyter \
  --version=0.8.2 \
  --values=values.yaml
```

## 3. References
* [Jupyter](https://jupyter.org/)
* [JupyterLab](https://jupyterlab.readthedocs.io/)
* [JupyterHub](https://jupyterhub.readthedocs.io/)
  * [z2jh](https://z2jh.jupyter.org/)
  * [helm chart](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/tree/master/jupyterhub)
