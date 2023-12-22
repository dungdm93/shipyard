resource "keycloak_oidc_google_identity_provider" "google" {
  realm         = keycloak_realm.kit106.id
  provider_id   = "google"
  client_id     = var.idp_google.client_id
  client_secret = var.idp_google.client_secret
  trust_email   = true
  hosted_domain = "dungdm93.me,dungdm93.local"
}
