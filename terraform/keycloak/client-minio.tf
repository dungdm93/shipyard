resource "keycloak_openid_client" "minio" {
  realm_id    = keycloak_realm.kit106.id
  client_id   = "minio"
  name        = "MinIO"
  description = "S3 compatible object storage"

  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  valid_redirect_uris = [
    "${local.keycloak_client_endpoints.minio}/oauth_callback"
  ]
}

resource "keycloak_openid_user_attribute_protocol_mapper" "minio-user_attribute_mapper" {
  realm_id  = keycloak_realm.kit106.id
  client_id = keycloak_openid_client.minio.id
  name      = "policy"

  user_attribute   = "minio-policy"
  claim_name       = "policy"
  claim_value_type = "String"
}
