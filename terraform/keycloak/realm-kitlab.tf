# http://{host}:{port}/admin/realms/{realm}/.well-known/openid-configuration
resource "keycloak_realm" "kitlab" {
  realm             = "kitlab"
  enabled           = true
  display_name      = "KiTLab Platform"
  display_name_html = "<h1>KiTLab Platform</h1>"

  # Login Settings
  registration_allowed = false
  # registration_email_as_username = true # TODO
  edit_username_allowed    = false
  reset_password_allowed   = true
  remember_me              = true
  verify_email             = false
  login_with_email_allowed = true
  duplicate_emails_allowed = false

  # Authentication
  access_token_lifespan    = "1h"
  sso_session_idle_timeout = "2h"

  # Mail
  # smtp_server {
  #   host     = "smtp.sendgrid.net"
  #   port     = 465
  #   ssl      = true
  #   starttls = false
  #
  #   from              = "hello@dungdm93.me"
  #   from_display_name = "KiTLab Platform"
  #
  #   auth {
  #     username = "api"
  #     password = "token"
  #   }
  # }
}
