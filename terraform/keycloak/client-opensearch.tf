resource "keycloak_openid_client" "opensearch" {
  realm_id    = keycloak_realm.kit106.id
  client_id   = "opensearch"
  name        = "OpenSearch"
  description = "The open-source suite for ingest, search, visualize, and analyze data"

  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = true
  valid_redirect_uris = [
    "${local.keycloak_client_endpoints.opensearch}/auth/openid/login"
  ]
  valid_post_logout_redirect_uris = [
    local.keycloak_client_endpoints.opensearch
  ]
}

resource "keycloak_openid_group_membership_protocol_mapper" "opensearch-group_membership_mapper" {
  realm_id   = keycloak_realm.kit106.id
  client_id  = keycloak_openid_client.opensearch.id
  name       = "groups"
  claim_name = "groups"

  full_path           = true
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}
