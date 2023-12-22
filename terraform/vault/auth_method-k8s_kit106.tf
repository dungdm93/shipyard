resource "vault_auth_backend" "k8s_kit106" {
  type        = "kubernetes"
  path        = "k8s/kit106"
  description = "Allow workloads running in k8s kit106 cluster using its Service Account to acquire secrets in Vault"
}

resource "vault_kubernetes_auth_backend_config" "k8s_kit106" {
  backend            = vault_auth_backend.k8s_kit106.path
  kubernetes_host    = "https://kit106.dungdm93.me:6443"
  kubernetes_ca_cert = var.vault_auth_methods.k8s_kit106.ca
  token_reviewer_jwt = var.vault_auth_methods.k8s_kit106.token
}

resource "vault_kubernetes_auth_backend_role" "kit106-cert_manager" {
  backend                          = vault_auth_backend.k8s_kit106.path
  role_name                        = "cert-manager"
  bound_service_account_names      = ["vault-issuer"]
  bound_service_account_namespaces = ["cert-manager"]
  audience                         = "vault://vault-issuer"
  token_policies                   = [vault_policy.service-cert_manager.name]
}
