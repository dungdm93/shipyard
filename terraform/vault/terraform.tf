terraform {
  required_version = ">= 0.14"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.11"
    }
  }
}

provider "vault" {
  address = var.vault.url
  token   = var.vault.token

  skip_tls_verify = true
}

variable "vault" {
  description = "Vault provider configurations"
  type = object({
    url   = string
    token = string
  })
}

variable "vault_auth_methods" {
  description = "Vault auth_methods configurations"
  type = object({
    keycloak = object({
      endpoint      = string
      client_id     = string
      client_secret = string
      ca_pem        = optional(string)
    })
    gitlab = object({
      endpoint = string
    })

    k8s_kit106 = object({
      ca    = string
      token = string
    })
  })
}

variable "infradb_accounts" {
  type = map(string)
}

variable "keycloak_oidc_clients" {
  type = map(object({
    client_id     = string
    client_secret = optional(string)
  }))
}
