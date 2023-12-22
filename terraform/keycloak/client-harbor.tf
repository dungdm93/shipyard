resource "keycloak_openid_client" "harbor" {
  realm_id    = keycloak_realm.kit106.id
  client_id   = "harbor"
  name        = "Harbor"
  description = "An open source trusted cloud native registry project that stores, signs, and scans content."

  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  valid_redirect_uris = [
    "${local.keycloak_client_endpoints.harbor}/c/oidc/callback"
  ]
}

resource "keycloak_openid_group_membership_protocol_mapper" "harbor-group_membership_mapper" {
  realm_id   = keycloak_realm.kit106.id
  client_id  = keycloak_openid_client.harbor.id
  name       = "groups"
  claim_name = "groups"

  full_path           = true
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}
