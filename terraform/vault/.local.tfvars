vault = {
  url   = "http://localhost:8200"
  token = "SuperSecr3t"
}

vault_auth_methods = {
  keycloak = {
    endpoint      = "http://keycloak:8080"
    client_id     = "vault"
    client_secret = "copy-this-from-keycloak"
    ca_pem        = null
  }
  gitlab = {
    endpoint = "https://git.dungdm93.me"
  }
}

infradb_accounts = {
  "vault"    = "v4ul1"
  "keycloak" = "k3yCl04ak"
}

keycloak_oidc_clients = {
  kubernetes = {
    client_id = "kubernetes"
  }
  vault = {
    client_id     = "vault"
    client_secret = "superlongvaultclientsecret"
  }
  grafana = {
    client_id     = "grafana"
    client_secret = "sup3r-l0ng-grafana-cl13n1s3cr37"
  }
}
