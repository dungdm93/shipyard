resource "cloudflare_access_application" "kibana" {
  account_id = var.cloudflare.account_id
  name       = "kibana"
  type       = "self_hosted"
  domain     = "kibana.${cloudflare_zone.dungdm93_me.zone}"
  logo_url   = "https://brandslogos.com/wp-content/uploads/images/elastic-kibana-logo.png"

  auto_redirect_to_identity  = true
  http_only_cookie_attribute = true
}

resource "cloudflare_access_policy" "kibana" {
  account_id     = var.cloudflare.account_id
  application_id = cloudflare_access_application.kibana.id
  name           = "default"
  precedence     = "1"
  decision       = "allow"

  include {
    group = [
      local.access_groups.dataops,
    ]
  }
}
