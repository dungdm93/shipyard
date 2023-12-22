data "keycloak_openid_client" "realm_management" {
  realm_id  = keycloak_realm.kit106.id
  client_id = "realm-management"
}

data "keycloak_role" "realm_management-create_client" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "create-client"
}

data "keycloak_role" "realm_management-impersonation" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "impersonation"
}

data "keycloak_role" "realm_management-manage_authorization" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "manage-authorization"
}

data "keycloak_role" "realm_management-manage_clients" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "manage-clients"
}

data "keycloak_role" "realm_management-manage_events" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "manage-events"
}

data "keycloak_role" "realm_management-manage_identity_providers" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "manage-identity-providers"
}

data "keycloak_role" "realm_management-manage_realm" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "manage-realm"
}

data "keycloak_role" "realm_management-manage_users" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "manage-users"
}

data "keycloak_role" "realm_management-query_clients" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "query-clients"
}

data "keycloak_role" "realm_management-query_groups" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "query-groups"
}

data "keycloak_role" "realm_management-query_realms" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "query-realms"
}

data "keycloak_role" "realm_management-query_users" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "query-users"
}

data "keycloak_role" "realm_management-realm_admin" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "realm-admin"
}

data "keycloak_role" "realm_management-view_authorization" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "view-authorization"
}

data "keycloak_role" "realm_management-view_clients" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "view-clients"
}

data "keycloak_role" "realm_management-view_events" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "view-events"
}

data "keycloak_role" "realm_management-view_identity_providers" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "view-identity-providers"
}

data "keycloak_role" "realm_management-view_realm" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "view-realm"
}

data "keycloak_role" "realm_management-view_users" {
  realm_id  = keycloak_realm.kit106.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = "view-users"
}
