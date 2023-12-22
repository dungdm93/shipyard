# Groups are devided into domains like kit106, kitlab,...
# Each domain has functional sub-group like:
# * kit106/data/analyst: Data Analyst a.k.a BI
# * kit106/data/engineer: Data Engineer a.k.a ETL
# * kit106/data/scientist: Data Scientist a.k.a AI/ML
# Special groups:
# * commons:
# * dataops: SRE members
# * services/<app>: Data mining Applications

resource "keycloak_group" "admin" {
  realm_id = keycloak_realm.kit106.id
  name     = "admin"
}

# keycloak_group_roles binding
resource "keycloak_group_roles" "admin_roles" {
  realm_id = keycloak_realm.kit106.id
  group_id = keycloak_group.admin.id

  role_ids = [
    data.keycloak_role.realm_management-manage_users.id,
    data.keycloak_role.realm_management-impersonation.id,
    data.keycloak_role.realm_management-view_authorization.id,
    data.keycloak_role.realm_management-view_clients.id,
    data.keycloak_role.realm_management-view_events.id,
    data.keycloak_role.realm_management-view_identity_providers.id,
    data.keycloak_role.realm_management-view_realm.id,
    data.keycloak_role.realm_management-view_users.id,
  ]
}

resource "keycloak_group" "editor" {
  realm_id = keycloak_realm.kit106.id
  name     = "editor"
}

resource "keycloak_group" "viewer" {
  realm_id = keycloak_realm.kit106.id
  name     = "viewer"
}

resource "keycloak_group" "commons" {
  realm_id = keycloak_realm.kit106.id
  name     = "commons"
}

resource "keycloak_default_groups" "default" {
  realm_id = keycloak_realm.kit106.id
  group_ids = [
    keycloak_group.commons.id
  ]
}
