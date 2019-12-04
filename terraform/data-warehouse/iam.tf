# Note:
# * use google_project_iam_member to bind a set of ROLES to a MEMBER
# * use google_storage_bucket_iam_binding to bind a ROLE to set of MEMBERS
# * use google_service_account_iam_binding to grant access to MEMBERS to perform actions as this SERVICE-ACCOUNT
# ref: https://cloud.google.com/iam/docs/understanding-roles#predefined_roles
# ref: https://www.terraform.io/docs/providers/google/r/google_project_iam.html

resource "google_project_iam_member" "devops" {
  for_each = toset([
    "roles/editor",
    "roles/container.clusterAdmin"
  ])
  role   = each.value
  member = "group:dataops@teko.vn"
}
