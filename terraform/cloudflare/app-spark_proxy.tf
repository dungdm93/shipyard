resource "cloudflare_access_application" "spark_proxy" {
  account_id = var.cloudflare.account_id
  name       = "spark-proxy"
  type       = "self_hosted"
  domain     = "spark.${cloudflare_zone.dungdm93_me.zone}"
  logo_url   = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Apache_Spark_logo.svg/320px-Apache_Spark_logo.svg.png"

  auto_redirect_to_identity  = true
  http_only_cookie_attribute = true
}

resource "cloudflare_access_policy" "spark_proxy" {
  account_id     = var.cloudflare.account_id
  application_id = cloudflare_access_application.spark_proxy.id
  name           = "default"
  precedence     = "1"
  decision       = "allow"

  include {
    group = [local.access_groups.data]
  }
}
