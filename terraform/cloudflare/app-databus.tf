resource "cloudflare_access_application" "databus" {
  account_id = var.cloudflare.account_id
  name       = "databus"
  type       = "self_hosted"
  domain     = "databus.${cloudflare_zone.dungdm93_me.zone}"
  logo_url   = "https://raw.githubusercontent.com/redpanda-data/redpanda/dev/docs/PANDA_sitting.jpg"

  auto_redirect_to_identity  = true
  http_only_cookie_attribute = true
}

resource "cloudflare_access_policy" "databus" {
  account_id     = var.cloudflare.account_id
  application_id = cloudflare_access_application.databus.id
  name           = "default"
  precedence     = "1"
  decision       = "allow"

  include {
    group = [
      local.access_groups.dataops,
      local.access_groups.dataetl,
    ]
  }
}
