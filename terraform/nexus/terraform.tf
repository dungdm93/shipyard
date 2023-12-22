terraform {
  required_version = ">= 1.2"

  required_providers {
    nexus = {
      source  = "datadrivers/nexus"
      version = "~> 1.21"
    }
  }
}

provider "nexus" {
  url      = var.nexus.url
  insecure = true
  username = var.nexus.username # env.NEXUS_USERNAME
  password = var.nexus.password # env.NEXUS_PASSWORD
}

variable "nexus" {
  description = "nexus provider configurations"
  type = object({
    url      = string
    username = string
    password = string
  })
}

variable "s3" {
  description = "S3 storage bucket configurations"
  type = object({
    endpoint   = string
    bucket     = string
    access_key = string
    secret_key = string
  })
}
