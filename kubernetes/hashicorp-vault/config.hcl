ui           = true
cluster_name = "dungdm93.me"

listener "tcp" {
  tls_disable     = 1
  address         = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  telemetry {
    unauthenticated_metrics_access = true
  }
}

{{ $username := printf "ref+file://%s#/vault/database/username" (requiredEnv "CONFIG") | fetchSecretValue -}}
{{ $password := printf "ref+file://%s#/vault/database/password" (requiredEnv "CONFIG") | fetchSecretValue -}}
storage "postgresql" {
  connection_url = "postgres://{{ $username }}:{{ $password }}@infradb.dungdm93.me:5432/vault?sslmode=disable"
  table          = "vault_kv_store"
  ha_enabled     = true
  ha_table       = "vault_ha_locks"
}

# storage "gcs" {
#   bucket     = "kit106-hashicorp-vault"
#   ha_enabled = "true"
# }

seal "gcpckms" {
  credentials = "/vault/userconfig/kms-creds/gcp-credentials.json"
  project     = "kit106-platform"
  region      = "global"
  key_ring    = "kit106-keyring"
  crypto_key  = "seal-key"
}

service_registration "kubernetes" {}

telemetry {
  disable_hostname = true
  prometheus_retention_time = "15m"
}
