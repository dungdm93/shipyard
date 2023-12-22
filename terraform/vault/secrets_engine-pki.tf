resource "vault_mount" "pki_root" {
  path                  = "pki/root"
  type                  = "pki"
  description           = "The PKI secrets engine generates dynamic X.509 certificates"
  max_lease_ttl_seconds = 315360000 # 10y
}

resource "vault_pki_secret_backend_config_urls" "pki_root" {
  backend = vault_mount.pki_root.path

  issuing_certificates = ["${var.vault.url}/v1/${vault_mount.pki_root.path}/ca"]

  ## CRL and OCSP endpoints must be accessible over HTTP, not HTTPS.
  # crl_distribution_points = ["http://vault.dungdm93.me/v1/${vault_mount.pki_root.path}/crl"]
  # ocsp_servers            = [...] # OCSP responder are not handled by Vault
}

resource "vault_mount" "pki_intermediate" {
  path                  = "pki/intermediate"
  type                  = "pki"
  description           = "The PKI secrets engine generates dynamic X.509 certificates"
  max_lease_ttl_seconds = 157680000 # 5y
}

resource "vault_pki_secret_backend_config_urls" "pki_intermediate" {
  backend = vault_mount.pki_intermediate.path

  issuing_certificates = ["${var.vault.url}/v1/${vault_mount.pki_intermediate.path}/ca"]

  ## CRL and OCSP endpoints must be accessible over HTTP, not HTTPS.
  # crl_distribution_points = ["http://vault.dungdm93.me/v1/${vault_mount.pki_root.path}/crl"]
  # ocsp_servers            = [...] # OCSP responder are not handled by Vault
}

resource "vault_pki_secret_backend_root_cert" "root_x1" {
  backend              = vault_mount.pki_root.path
  type                 = "internal"
  common_name          = "KiT106 Root X1"
  exclude_cn_from_sans = true

  alt_names    = ["dungdm93.me", "dungdm93.local"]
  ttl          = 315360000 # 10y
  format       = "pem"
  key_type     = "ed25519" # rsa | ec | ed25519
  organization = "KiT106"
  ou           = "Platform"
  country      = "VN"
  locality     = "Hanoi"
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate_e1" {
  backend     = vault_mount.pki_intermediate.path
  type        = "internal"
  common_name = "KiT106 Authority E1"

  key_type = "ed25519" # rsa | ec | ed25519
}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate_e1" {
  backend              = vault_mount.pki_root.path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.intermediate_e1.csr
  common_name          = vault_pki_secret_backend_intermediate_cert_request.intermediate_e1.common_name
  exclude_cn_from_sans = true

  alt_names    = ["dungdm93.me", "dungdm93.local"]
  ttl       = 157680000 # 5y
  format    = "pem"

  organization = "KiT106"
  ou           = "Platform"
  country      = "VN"
  locality     = "Hanoi"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate_e1" {
  backend     = vault_mount.pki_intermediate.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.intermediate_e1.certificate
}

resource "vault_pki_secret_backend_role" "cert_manager" {
  backend = vault_mount.pki_intermediate.path
  name    = "cert-manager"

  allow_any_name = true
  require_cn     = false

  ttl      = 7776000  # 90d
  max_ttl  = 31536000 # 1y
  key_type = "any"    # rsa | ec | ed25519 | any
}
