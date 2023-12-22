resource "keycloak_openid_client" "datahub" {
  realm_id    = keycloak_realm.kit106.id
  client_id   = "datahub"
  name        = "Datahub"
  description = "A Metadata Platform"

  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  valid_redirect_uris = [
    "${local.keycloak_client_endpoints.datahub}/callback/oidc"
  ]
}

resource "keycloak_openid_group_membership_protocol_mapper" "datahub-group_membership_mapper" {
  realm_id   = keycloak_realm.kit106.id
  client_id  = keycloak_openid_client.datahub.id
  name       = "groups"
  claim_name = "groups"

  full_path           = true
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}
