terraform {
  required_version = ">= 0.14"

  required_providers {
    harbor = {
      source  = "goharbor/harbor"
      version = "3.10.4"
    }
  }
}

provider "harbor" {
  url      = var.harbor.url
  username = var.harbor.username
  password = var.harbor.password
}

variable "harbor" {
  description = "Harbor provider configurations"
  type = object({
    url      = string
    username = string
    password = string
  })
}

variable "harbor_oidc_client" {
  type = object({
    client_id     = string
    client_secret = string
  })
}
