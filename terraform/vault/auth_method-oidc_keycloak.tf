resource "vault_jwt_auth_backend" "keycloak" {
  type                  = "oidc"
  path                  = "oidc/keycloak"
  description           = "Allow users login to Vault using KeyCloak"
  oidc_discovery_url    = "${var.vault_auth_methods.keycloak.endpoint}/realms/kit106"
  oidc_discovery_ca_pem = var.vault_auth_methods.keycloak.ca_pem
  oidc_client_id        = var.vault_auth_methods.keycloak.client_id
  oidc_client_secret    = var.vault_auth_methods.keycloak.client_secret
  bound_issuer          = "${var.vault_auth_methods.keycloak.endpoint}/realms/kit106"
  default_role          = "default"
  tune {
    listing_visibility = "unauth"
    default_lease_ttl  = "72h"  # 3d
    max_lease_ttl      = "168h" # 7d
    token_type         = "default-service"
  }
}

resource "vault_jwt_auth_backend_role" "keycloak-default" {
  backend   = vault_jwt_auth_backend.keycloak.path
  role_name = "default"
  role_type = "oidc"
  allowed_redirect_uris = [
    # for CLI
    "http://localhost:8250/oidc/callback",
    # for WebUI
    "${var.vault.url}/ui/vault/auth/${vault_jwt_auth_backend.keycloak.path}/oidc/callback",
  ]

  user_claim   = "preferred_username"
  groups_claim = "groups"
}

resource "vault_identity_group" "keycloak-admin" {
  name     = "keycloak-admin"
  type     = "external"
  policies = [vault_policy.admin.name]
}

resource "vault_identity_group_alias" "keycloak-admin" {
  name           = "/admin"
  mount_accessor = vault_jwt_auth_backend.keycloak.accessor
  canonical_id   = vault_identity_group.keycloak-admin.id
}

resource "vault_identity_group" "keycloak-editor" {
  name     = "keycloak-editor"
  type     = "external"
  policies = [vault_policy.editor.name]
}

resource "vault_identity_group_alias" "keycloak-editor" {
  name           = "/editor"
  mount_accessor = vault_jwt_auth_backend.keycloak.accessor
  canonical_id   = vault_identity_group.keycloak-editor.id
}
