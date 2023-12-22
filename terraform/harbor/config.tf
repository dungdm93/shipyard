resource "harbor_config_system" "main" {
  project_creation_restriction = "adminonly"
}

resource "harbor_garbage_collection" "main" {
  schedule        = "Daily"
  delete_untagged = true
}

resource "harbor_purge_audit_log" "main" {
  schedule             = "Daily"
  audit_retention_hour = 1080 # 45d
  include_operations   = "create,delete,pull"
}

resource "harbor_interrogation_services" "main" {
  vulnerability_scan_policy = "Daily"
}
