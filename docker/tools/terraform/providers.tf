terraform {
  required_providers {
    # Amazon AWS
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 2.70"
    # }

    # Google Cloud Platform
    google = {
      source  = "hashicorp/google"
      version = "~> 3.30"
    }

    # Microsoft Azure
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 2.20"
    # }

    # Oracle Cloud Infrastructure
    # oci = {
    #   source  = "hashicorp/oci"
    #   version = "~> 3.80"
    # }

    # OpenStack
    # openstack = {
    #   source  = "terraform-providers/openstack"
    #   version = "~> 1.26"
    # }

    # VMware vSphere
    # vsphere = {
    #   source  = "hashicorp/vsphere"
    #   version = "~> 1.20"
    # }

    # Alibaba Cloud
    # alicloud = {
    #   source  = "hashicorp/alicloud"
    #   version = "~> 1.90"
    # }

    # Cloudflare
    cloudflare = {
      source  = "terraform-providers/cloudflare"
      version = "~> 2.4"
    }

    # Database PostgreSQL
    postgresql = {
      source  = "terraform-providers/postgresql"
      version = "~> 1.5"
    }

    # Database MySQL
    mysql = {
      source  = "terraform-providers/mysql"
      version = "~> 1.9"
    }

    # RabbitMQ
    # rabbitmq = {
    #   source  = "terraform-providers/rabbitmq"
    #   version = "1.1"
    # }

    # Hashicorp Vault
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.12"
    }

    ##### Custom plugins - Manual install #####
    # minio = {
    #   source  = "github.com/aminueza/minio"
    #   version = "1.1.0"
    # }
    # nexus = {
    #   source  = "github.com/datadrivers/nexus"
    #   version = "1.6.0"
    # }
    # keycloak = {
    #   source  = "github.com/mrparkers/keycloak"
    #   version = "1.20.0"
    # }
  }
}
