terraform {
  # Version of Terraform to include in the bundle. An exact version number is required.
  version = "0.12.24"
}

# Define which provider plugins are to be included
providers {
  # Amazon AWS
  # aws = ["~> 2.50"]

  # Google Cloud Platform
  google = ["~> 2.20", "~> 3.20"]

  # Microsoft Azure
  # azurerm = ["~> 2.0"]

  # Oracle Cloud Infrastructure
  # oci = ["~> 3.60"]

  # OpenStack
  # openstack = ["~> 1.26"]

  # VMware vSphere
  # vsphere = ["~> 1.15"]

  # Alibaba Cloud
  # alicloud = ["~> 1.75"]

  # Cloudflare
  cloudflare = ["~> 2.4"]

  # Database PostgreSQL
  postgresql = ["~> 1.5"]

  # Database MySQL
  mysql = ["~> 1.9"]

  # RabbitMQ
  # rabbitmq = ["1.1"]

  ##### TODO: Custom plugins #####
  # minio = ["1.1.0"]
  # nexus = ["1.6.0"]
}
