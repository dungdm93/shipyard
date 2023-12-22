################### kit106 ###################
resource "keycloak_group" "kit106" {
  realm_id = keycloak_realm.kit106.id
  name     = "kit106"
}

resource "keycloak_group" "kit106_data" {
  realm_id  = keycloak_realm.kit106.id
  name      = "data" # kit106/data
  parent_id = keycloak_group.kit106.id
}

resource "keycloak_group" "kit106_data_analyst" {
  realm_id  = keycloak_realm.kit106.id
  name      = "analyst" # kit106/data/analyst
  parent_id = keycloak_group.kit106_data.id
}

resource "keycloak_group" "kit106_data_engineer" {
  realm_id  = keycloak_realm.kit106.id
  name      = "engineer" # kit106/data/engineer
  parent_id = keycloak_group.kit106_data.id
}

resource "keycloak_group" "kit106_data_scientist" {
  realm_id  = keycloak_realm.kit106.id
  name      = "scientist" # kit106/data/scientist
  parent_id = keycloak_group.kit106_data.id
}
