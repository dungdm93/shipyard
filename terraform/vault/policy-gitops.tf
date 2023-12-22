data "vault_policy_document" "git-dataops" {
  rule {
    path         = "secret/data/gitops/*"
    capabilities = ["read"]
    description  = "Secrets for GitOps"
  }
}

resource "vault_policy" "git-dataops" {
  name   = "git-dataops"
  policy = data.vault_policy_document.git-dataops.hcl
}

data "vault_policy_document" "git-dataops_lab" {
  rule {
    path         = "secret-lab/data/*"
    capabilities = ["read"]
    description  = "Secrets for DataLab"
  }
}

resource "vault_policy" "git-dataops_lab" {
  name   = "git-dataops_lab"
  policy = data.vault_policy_document.git-dataops_lab.hcl
}

data "vault_policy_document" "git-dataops_datasources" {
  rule {
    path         = "secret/data/datasources/*"
    capabilities = ["read"]
    description  = "DataSources for streaming ingestion"
  }
  rule {
    path         = "secret/data/gitops/alluvial/*"
    capabilities = ["read"]
    description  = "Alluvial for streaming ingestion"
  }
}

resource "vault_policy" "git-dataops_datasources" {
  name   = "git-dataops_datasources"
  policy = data.vault_policy_document.git-dataops_datasources.hcl
}
