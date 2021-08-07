terraform {
  required_providers {
    ## CNCF Kubernetes
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.4"
    }

    ## CNCF Helm
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.2"
    }

    ## Amazon AWS
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 3.50"
    # }

    ## Google Cloud Platform
    google = {
      source  = "hashicorp/google"
      version = "~> 3.75"
    }

    ## Microsoft Azure
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 2.70"
    # }

    ## Oracle Cloud Infrastructure
    # oci = {
    #   source  = "hashicorp/oci"
    #   version = "~> 4.38"
    # }

    ## OpenStack
    # openstack = {
    #   source  = "terraform-provider-openstack/openstack"
    #   version = "~> 1.40"
    # }

    ## VMware vSphere
    # vsphere = {
    #   source  = "hashicorp/vsphere"
    #   version = "~> 2.0"
    # }

    ## Alibaba Cloud
    # alicloud = {
    #   source  = "aliyun/alicloud"
    #   version = "~> 1.128"
    # }

    ## Cloudflare
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.25"
    }

    ## Database PostgreSQL
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.10"
    }

    ## Database MySQL
    mysql = {
      source  = "winebarrel/mysql"
      version = "~> 1.10"
    }

    ## RabbitMQ
    # rabbitmq = {
    #   source  = "cyrilgdn/rabbitmq"
    #   version = "1.5"
    # }

    ## Hashicorp Vault
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.22"
    }

    # Grafana
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.13"
    }

    ## MinIO
    minio = {
      source  = "aminueza/minio"
      version = "~> 1.2"
    }

    ## Sonatype Nexus
    nexus = {
      source  = "datadrivers/nexus"
      version = "~> 1.12"
    }

    ## Keycloak
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.2"
    }
  }
}
