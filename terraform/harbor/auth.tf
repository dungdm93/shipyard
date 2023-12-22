resource "harbor_config_auth" "oidc" {
  auth_mode          = "oidc_auth"
  primary_auth_mode  = true
  oidc_name          = "keycloak"
  oidc_endpoint      = "https://keycloak.dungdm93.me/realms/kit106"
  oidc_client_id     = var.harbor_oidc_client.client_id
  oidc_client_secret = var.harbor_oidc_client.client_secret
  oidc_scope         = "openid,email,offline_access"
  oidc_verify_cert   = true
  oidc_auto_onboard  = true
  oidc_user_claim    = "preferred_username"
  oidc_groups_claim  = "groups"
  oidc_admin_group   = "/admin"
}
