terraform {
  required_version = ">= 0.14"

  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "~> 4.1.0"
    }
  }
}

provider "keycloak" {
  url       = var.keycloak.url
  realm     = "master"
  client_id = "admin-cli"
  username  = var.keycloak.username
  password  = var.keycloak.password

  tls_insecure_skip_verify = true
}

variable "keycloak" {
  description = "Keycloak provider configurations"
  type = object({
    url      = string
    username = string
    password = string
  })
}

variable "idp_google" {
  description = "Google Identity provider"
  type = object({
    client_id     = string
    client_secret = string
  })
}

output "openid_clients" {
  value = {
    kubernetes = {
      client_id : keycloak_openid_client.kubernetes.client_id
    }
    grafana = {
      client_id : keycloak_openid_client.grafana.client_id
      client_secret : keycloak_openid_client.grafana.client_secret
    }
    jupyterhub = {
      client_id : keycloak_openid_client.jupyterhub.client_id
      client_secret : keycloak_openid_client.jupyterhub.client_secret
    }
    airflow = {
      client_id : keycloak_openid_client.airflow.client_id
      client_secret : keycloak_openid_client.airflow.client_secret
    }
    superset = {
      client_id : keycloak_openid_client.superset.client_id
      client_secret : keycloak_openid_client.superset.client_secret
    }
    vault = {
      client_id : keycloak_openid_client.vault.client_id
      client_secret : keycloak_openid_client.vault.client_secret
    }
    trino = {
      client_id : keycloak_openid_client.trino.client_id
      client_secret : keycloak_openid_client.trino.client_secret
    }
    datahub = {
      client_id : keycloak_openid_client.datahub.client_id
      client_secret : keycloak_openid_client.datahub.client_secret
    }
    harbor = {
      client_id : keycloak_openid_client.harbor.client_id
      client_secret : keycloak_openid_client.harbor.client_secret
    }
    dbt = {
      client_id : keycloak_openid_client.dbt.client_id
      client_secret : keycloak_openid_client.dbt.client_secret
    }
    minio = {
      client_id : keycloak_openid_client.minio.client_id
      client_secret : keycloak_openid_client.minio.client_secret
    }
    opensearch = {
      client_id : keycloak_openid_client.opensearch.client_id
      client_secret : keycloak_openid_client.opensearch.client_secret
    }
    export_service = {
      client_id : keycloak_openid_client.export_service.client_id
      client_secret : keycloak_openid_client.export_service.client_secret
    }
  }
  sensitive = true
}
