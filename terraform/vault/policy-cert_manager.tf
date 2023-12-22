# https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-cert-manager#configure-pki-secrets-engine
# https://developer.hashicorp.com/vault/api-docs/secret/pki
data "vault_policy_document" "service-cert_manager" {
  # Sign Certificate
  rule {
    path         = "${vault_mount.pki_intermediate.path}/sign/${vault_pki_secret_backend_role.cert_manager.name}"
    capabilities = ["create", "update"]
  }
  rule {
    path         = "${vault_mount.pki_intermediate.path}/issuer/+/sign/${vault_pki_secret_backend_role.cert_manager.name}"
    capabilities = ["create", "update"]
  }

  # Generate Certificate and Key
  rule {
    path         = "${vault_mount.pki_intermediate.path}/issue/${vault_pki_secret_backend_role.cert_manager.name}"
    capabilities = ["create"]
  }

  rule {
    path         = "${vault_mount.pki_intermediate.path}/issuer/+/issue/${vault_pki_secret_backend_role.cert_manager.name}"
    capabilities = ["create"]
  }
}

resource "vault_policy" "service-cert_manager" {
  name   = "service-cert_manager"
  policy = data.vault_policy_document.service-cert_manager.hcl
}
