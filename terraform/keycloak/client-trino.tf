resource "keycloak_openid_client" "trino" {
  realm_id    = keycloak_realm.kit106.id
  client_id   = "trino"
  name        = "Trino"
  description = "A query engine that runs at ludicrous speed"

  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  valid_redirect_uris = [
    "${local.keycloak_client_endpoints.trino}/oauth2/callback",
    "${local.keycloak_client_endpoints.trino-xs}/oauth2/callback"
  ]
}

resource "keycloak_openid_group_membership_protocol_mapper" "trino-group_membership_mapper" {
  realm_id   = keycloak_realm.kit106.id
  client_id  = keycloak_openid_client.trino.id
  name       = "groups"
  claim_name = "groups"

  full_path           = true
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}
