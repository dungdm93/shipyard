Data stacks
===========
Template for build data warehouse stack based on Kubernetes

## 1. Folder structure
* [`docker`](/docker): Dockerfile and other stuffs for build docker images.
* [`helm`](/helm): Helm charts for data services

## 2. Coding
### 2.1 helm

test helm template
```
export VALUES=examples/<file>.yaml
task helm:gen
```

test apply
```
task helm:apply
```
