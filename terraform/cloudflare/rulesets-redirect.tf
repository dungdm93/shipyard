resource "cloudflare_ruleset" "iam" {
  zone_id = cloudflare_zone.dungdm93_me.id
  kind    = "zone"
  name    = "default"
  phase   = "http_request_dynamic_redirect"

  rules {
    enabled     = true
    action      = "redirect"
    description = "[KiTLab] IAM console"
    expression  = <<EOT
(http.host eq "iam.dungdm93.me" and http.request.uri.path eq "/lab")
EOT
    action_parameters {
      from_value {
        status_code           = 308
        preserve_query_string = false
        target_url {
          value = "https://keycloak.dungdm93.me/admin/kitlab/console/"
        }
      }
    }
  }

  rules {
    enabled     = true
    action      = "redirect"
    description = "IAM console"
    expression  = <<EOT
(http.host eq "iam.dungdm93.me")
EOT
    action_parameters {
      from_value {
        status_code           = 308
        preserve_query_string = false
        target_url {
          value = "https://keycloak.dungdm93.me/admin/kit106/console/"
        }
      }
    }
  }
}
