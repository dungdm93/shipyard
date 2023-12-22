resource "keycloak_openid_client" "grafana" {
  realm_id    = keycloak_realm.kit106.id
  client_id   = "grafana"
  name        = "Grafana"
  description = "The open observability platform"

  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  valid_redirect_uris = [
    "${local.keycloak_client_endpoints.grafana}/login/generic_oauth"
  ]
}
