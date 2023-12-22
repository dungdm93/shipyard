remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "kit106-platform"
    prefix = "terraform/postgresql"

    skip_bucket_creation = true
  }
}

inputs = {
  postgresql = {
    host     = "infradb.dungdm93.me"
    port     = 5432
    username = get_env("POSTGRESQL_USERNAME")
    password = get_env("POSTGRESQL_PASSWORD")
  }
}
