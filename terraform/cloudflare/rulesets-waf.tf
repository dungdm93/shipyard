resource "cloudflare_ruleset" "keycloak" {
  zone_id = cloudflare_zone.dungdm93_me.id
  kind    = "zone"
  name    = "default"
  phase   = "http_request_firewall_custom"

  rules {
    enabled     = true
    action      = "skip"
    description = "Allow Keycloak discovery endpoints"
    expression  = <<EOT
http.host eq "keycloak.dungdm93.me"
and (
  http.request.uri.path eq "/realms/kit106/protocol/saml/descriptor" or
  http.request.uri.path eq "/realms/kit106/.well-known/openid-configuration"
)
EOT
    action_parameters {
      products = ["bic"]
    }
    logging {
      enabled = false
    }
  }
}
