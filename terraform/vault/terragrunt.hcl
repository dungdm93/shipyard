remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "kit106-platform"
    prefix = "terraform/vault"

    skip_bucket_creation = true
  }
}

dependency "postgresql" {
  config_path = "../postgresql"
}

dependency "keycloak" {
  config_path = "../keycloak"
}

inputs = {
  vault = {
    url   = "https://vault.dungdm93.me"
    token = get_env("VAULT_ROOT_TOKEN")
  }

  vault_auth_methods = {
    keycloak = {
      endpoint      = "https://keycloak.dungdm93.me"
      client_id     = dependency.keycloak.outputs.openid_clients.vault.client_id
      client_secret = dependency.keycloak.outputs.openid_clients.vault.client_secret
      ca_pem        = null # file(get_env("OIDC_CA_CRT_FILE"))
    }
    gitlab = {
      endpoint = "https://git.dungdm93.me"
    }

    k8s_kit106 = {
      ca    = get_env("VAULT_K8S_KIT106_CA")
      token = get_env("VAULT_K8S_KIT106_TOKEN")
    }
  }

  infradb_accounts      = dependency.postgresql.outputs.accounts
  keycloak_oidc_clients = dependency.keycloak.outputs.openid_clients
}
