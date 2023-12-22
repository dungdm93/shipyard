remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "kit106-platform"
    prefix = "terraform/keycloak"

    skip_bucket_creation = true
  }
}

inputs = {
  keycloak = {
    url      = "https://keycloak.dungdm93.me"
    username = get_env("KEYCLOAK_ADMIN_USERNAME")
    password = get_env("KEYCLOAK_ADMIN_PASSWORD")
  }

  idp_google = {
    client_id     = get_env("KEYCLOAK_IDP_GOOGLE_CLIENT_ID")
    client_secret = get_env("KEYCLOAK_IDP_GOOGLE_CLIENT_SECRET")
  }
}
