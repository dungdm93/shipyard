resource "keycloak_openid_client" "jupyterhub" {
  realm_id    = keycloak_realm.kit106.id
  client_id   = "jupyterhub"
  name        = "JupyterHub"
  description = "A multi-user version of the notebook designed for companies, classrooms and research labs"

  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  valid_redirect_uris = [
    "${local.keycloak_client_endpoints.jupyterhub}/hub/oauth_callback"
  ]
}
