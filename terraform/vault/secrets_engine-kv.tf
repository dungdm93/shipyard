resource "vault_mount" "secret" {
  path        = "secret"
  type        = "kv-v2"
  description = "The KV (a.k.a generic) secrets engine is used to store arbitrary secrets"
}

resource "vault_mount" "secret-lab" {
  path        = "secret-lab"
  type        = "kv-v2"
  description = "[KiTLab] The KV (a.k.a generic) secrets engine is used to store arbitrary secrets"
}

resource "vault_generic_secret" "services-infradb_accounts" {
  for_each = var.infradb_accounts

  path = "${vault_mount.secret.path}/services/infradb/accounts/${each.key}"
  data_json = jsonencode({
    "username" = each.key
    "password" = each.value
  })
}

resource "vault_generic_secret" "services-keycloak_oidc_clients" {
  for_each = var.keycloak_oidc_clients

  path      = "${vault_mount.secret.path}/services/keycloak/oidc-clients/${each.key}"
  data_json = jsonencode(each.value)
}

resource "vault_generic_secret" "gitops-databases" {
  for_each = var.infradb_accounts

  path = "${vault_mount.secret.path}/gitops/${each.key}/database"
  data_json = jsonencode({
    "username" = each.key
    "password" = each.value
  })
}

resource "vault_generic_secret" "gitops-auth_oidc" {
  for_each = var.keycloak_oidc_clients

  path      = "${vault_mount.secret.path}/gitops/${each.key}/auth"
  data_json = jsonencode(each.value)
}
