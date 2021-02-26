terraform {
  required_providers {
    ## CNCF Kubernetes
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

    ## CNCF Helm
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.0"
    }

    ## Amazon AWS
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 2.70"
    # }

    ## Google Cloud Platform
    google = {
      source  = "hashicorp/google"
      version = "~> 3.50"
    }

    ## Microsoft Azure
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 2.40"
    # }

    ## Oracle Cloud Infrastructure
    # oci = {
    #   source  = "hashicorp/oci"
    #   version = "~> 4.10"
    # }

    ## OpenStack
    # openstack = {
    #   source  = "terraform-provider-openstack/openstack"
    #   version = "~> 1.30"
    # }

    ## VMware vSphere
    # vsphere = {
    #   source  = "hashicorp/vsphere"
    #   version = "~> 1.20"
    # }

    ## Alibaba Cloud
    # alicloud = {
    #   source  = "aliyun/alicloud"
    #   version = "~> 1.100"
    # }

    ## Cloudflare
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.15"
    }

    ## Database PostgreSQL
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.10"
    }

    ## Database MySQL
    mysql = {
      source  = "petoju/mysql"
      version = "~> 2.2"
    }

    ## RabbitMQ
    # rabbitmq = {
    #   source  = "cyrilgdn/rabbitmq"
    #   version = "1.5"
    # }

    ## Hashicorp Vault
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.18"
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
      version = "2.2"
    }
  }
}
