resource "keycloak_openid_client" "kubernetes" {
  realm_id    = keycloak_realm.kit106.id
  client_id   = "kubernetes"
  name        = "kubernetes"
  description = "An open-source container-orchestration system for automated deployment, scaling, and management."

  access_type                = "PUBLIC"
  pkce_code_challenge_method = "S256"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  valid_redirect_uris = [
    "http://localhost:8000",
    "http://localhost:18000",
    # https://developers.google.com/identity/protocols/oauth2/native-app
    "urn:ietf:wg:oauth:2.0:oob",
  ]
}

resource "keycloak_openid_group_membership_protocol_mapper" "kubernetes-group_membership_mapper" {
  realm_id   = keycloak_realm.kit106.id
  client_id  = keycloak_openid_client.kubernetes.id
  name       = "groups"
  claim_name = "groups"

  full_path           = true
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}
