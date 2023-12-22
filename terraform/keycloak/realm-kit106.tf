locals {
  keycloak_password_policy = [
    "length(8)",
    "notUsername",
    # "upperCase(1)",
    # "lowerCase(1)",
    # "specialChars(1)",
    # "digits(1)",
    # "forceExpiredPasswordChange(365)"
  ]
}

# http://{host}:{port}/admin/realms/{realm}/.well-known/openid-configuration
resource "keycloak_realm" "kit106" {
  realm             = "kit106"
  enabled           = true
  display_name      = "KiT106 Platform"
  display_name_html = "<h1>KiT106 Platform</h1>"

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
  password_policy          = join(" and ", local.keycloak_password_policy)
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
  #   from_display_name = "KiT106 Platform"
  #
  #   auth {
  #     username = "api"
  #     password = "token"
  #   }
  # }
}

resource "keycloak_realm_events" "kit106" {
  realm_id = keycloak_realm.kit106.id

  events_enabled    = true
  events_expiration = 3888000 # 45d

  admin_events_enabled         = true
  admin_events_details_enabled = true
}
