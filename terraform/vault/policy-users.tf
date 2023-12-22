data "vault_policy_document" "admin" {
  rule {
    path         = "secret/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "allow all on secrets"
  }

  rule {
    path         = "secret-lab/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "[DataLab] allow all on secrets"
  }

  rule {
    path         = "*"
    capabilities = ["read", "list"]
    description  = "read-only other paths"
  }
}

resource "vault_policy" "admin" {
  name   = "admin"
  policy = data.vault_policy_document.admin.hcl
}

data "vault_policy_document" "editor" {
  rule {
    path         = "secret/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "allow all on secrets"
  }

  rule {
    path         = "secret/gitops/*"
    capabilities = ["deny"]
    description  = "except secrets used by GitOps CI/CD"
  }

  rule {
    path         = "secret-lab/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "[DataLab] allow all on secrets"
  }
}

resource "vault_policy" "editor" {
  name   = "editor"
  policy = data.vault_policy_document.editor.hcl
}
