locals {
  postgres_catalogs = {
    # "database" = "username"
    "airflow"        = "airflow"
    "datahub"        = "datahub"
    "druid"          = "druid"
    "grafana-oncall" = "grafana-oncall"
    "grafana"        = "grafana"
    "harbor"         = "harbor"
    "hms"            = "hive"
    "jupyterhub"     = "jupyterhub"
    "keycloak"       = "keycloak"
    "superset"       = "superset"
    "vault"          = "vault"
  }
}

resource "postgresql_database" "databases" {
  for_each = toset(keys(local.postgres_catalogs))

  name             = each.value
  owner            = local.postgres_catalogs[each.key]
  connection_limit = 256
  encoding         = "UTF8"
  lc_collate       = "en_US.utf8"
  lc_ctype         = "en_US.utf8"

  depends_on = [postgresql_role.users]
  lifecycle { prevent_destroy = true }
}

resource "postgresql_role" "users" {
  for_each = toset(values(local.postgres_catalogs))

  name             = each.value
  password         = base64sha256("[${each.value}@postgresql]")
  login            = true
  connection_limit = 256
}
