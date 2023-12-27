resource "cloudflare_zone" "dungdm93_me" {
  account_id = var.cloudflare.account_id
  zone       = "dungdm93.me"
}
