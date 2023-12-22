### https://docs.gitlab.com/ee/ci/examples/authenticating-with-hashicorp-vault/
resource "vault_jwt_auth_backend" "gitlab" {
  type         = "jwt"
  path         = "jwt/gitlab"
  description  = "Allow GitLab CI/CD pipelines read HashiCorp's Vault secrets"
  jwks_url     = "${var.vault_auth_methods.gitlab.endpoint}/-/jwks"
  bound_issuer = replace(var.vault_auth_methods.gitlab.endpoint, "/^[\\w+]+:///", "")
}

resource "vault_jwt_auth_backend_role" "gitlab-dataops_kit106_cluster" {
  backend   = vault_jwt_auth_backend.gitlab.path
  role_name = "dataops_kit106_cluster"
  role_type = "jwt"

  user_claim = "project_path"
  bound_claims = {
    namespace_path = "dataops"
    project_path   = "dataops/kit106.cluster"
  }

  token_policies = [vault_policy.git-dataops.name]
}

resource "vault_jwt_auth_backend_role" "gitlab-dataops_kitlab_cluster" {
  backend   = vault_jwt_auth_backend.gitlab.path
  role_name = "dataops_kitlab_cluster"
  role_type = "jwt"

  user_claim = "project_path"
  bound_claims = {
    namespace_path = "dataops"
    project_path   = "dataops/kitlab.cluster"
  }

  token_policies = [vault_policy.git-dataops_lab.name]
}

resource "vault_jwt_auth_backend_role" "gitlab-dataops_datasources" {
  backend   = vault_jwt_auth_backend.gitlab.path
  role_name = "dataops_datasources"
  role_type = "jwt"

  user_claim = "project_path"
  bound_claims = {
    namespace_path = "dataops"
    project_path   = "dataops/datasources"
  }

  token_policies = [vault_policy.git-dataops_datasources.name]
}
