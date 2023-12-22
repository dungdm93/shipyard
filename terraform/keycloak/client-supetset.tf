resource "keycloak_openid_client" "superset" {
  realm_id    = keycloak_realm.kit106.id
  client_id   = "superset"
  name        = "Superset"
  description = "The modern data exploration and visualization platform"

  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = true
  valid_redirect_uris = [
    "${local.keycloak_client_endpoints.superset}/oauth-authorized/keycloak"
  ]
}
