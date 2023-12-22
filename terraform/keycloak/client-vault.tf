locals {
  keycloak_client_vault = {
    oidc_keycloak_path = "oidc/keycloak"
  }
}

resource "keycloak_openid_client" "vault" {
  realm_id    = keycloak_realm.kit106.id
  client_id   = "vault"
  name        = "Vault"
  description = "A tool for secrets management, encryption as a service, and privileged access management"

  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  valid_redirect_uris = [
    # for CLI
    "http://localhost:8250/oidc/callback",
    # for WebUI
    "${local.keycloak_client_endpoints.vault}/ui/vault/auth/${local.keycloak_client_vault.oidc_keycloak_path}/oidc/callback",
  ]
}

resource "keycloak_openid_group_membership_protocol_mapper" "vault_group-membership_mapper" {
  realm_id   = keycloak_realm.kit106.id
  client_id  = keycloak_openid_client.vault.id
  name       = "groups"
  claim_name = "groups"

  full_path           = true
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}
