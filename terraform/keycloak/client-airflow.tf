resource "keycloak_openid_client" "airflow" {
  realm_id    = keycloak_realm.kit106.id
  client_id   = "airflow"
  name        = "Airflow"
  description = "The workflow management platform"

  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  valid_redirect_uris = [
    "${local.keycloak_client_endpoints.airflow}/oauth-authorized/keycloak"
  ]
}
