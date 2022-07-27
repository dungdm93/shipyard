Data stacks
===========
Template for build data warehouse stack based on Kubernetes

## 1. Folder structure
* [`docker`](/docker): Dockerfile and other stuffs for build docker images.
* [`helm`](/helm): Helm charts for data services

## 2. Coding
### 2.1 Helm chart
#### 2.1.1 Test Helm template

* Install [Helm](https://helm.sh/docs/intro/install/)
* Install [Go Task runner](https://taskfile.dev/installation/)
* Run commands
    ```sh
    # Go to the component folder
    cd helm/<component>

    # Set VALUE file via environment variable
    export VALUES=examples/<file>.yaml

    # Update Helm dependencies
    task helm:dep

    # Generate manifest files in folder ./build
    task helm:gen

    # Apply to K8s cluster
    task helm:apply

    # [Optional] Clean manifest files
    task helm:clean
    ```
