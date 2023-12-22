remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "kit106-platform"
    prefix = "terraform/harbor"

    skip_bucket_creation = true
  }
}

dependency "keycloak" {
  config_path = "../keycloak"
}

inputs = {
  harbor = {
    url   = "https://harbor.dungdm93.me"
    username = get_env("HARBOR_ADMIN_USERNAME")
    password = get_env("HARBOR_ADMIN_PASSWORD")
  }

  harbor_oidc_client = {
    client_id     = dependency.keycloak.outputs.openid_clients.harbor.client_id
    client_secret = dependency.keycloak.outputs.openid_clients.harbor.client_secret
  }
}
