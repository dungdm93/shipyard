locals {
  catalogs = {
    # "bucket" = "username"
    "nexus" = "nexus"
  }
}

resource "minio_s3_bucket" "buckets" {
	for_each = toset(keys(local.catalogs))

  bucket = each.value
  acl    = "private"

  lifecycle { prevent_destroy = true }
}

resource "minio_iam_user" "users" {
	for_each = toset(values(local.catalogs))

  name          = each.value
  secret        = base64sha256("[${each.value}@minio]")
  force_destroy = true
}

resource "minio_iam_user_policy_attachment" "policy_attachments" {
	for_each = local.catalogs

  user_name   = minio_iam_user.users[each.value].name
  policy_name = minio_iam_policy.policies[each.key].name
}

resource "minio_iam_policy" "policies" {
	for_each = toset(values(local.catalogs))

  name   = "nexus"
  policy = data.minio_iam_policy_document.policies[each.value].json
}

data "minio_iam_policy_document" "policies" {
	for_each = toset(values(local.catalogs))

  statement {
    sid     = "1"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${each.value}",
      "arn:aws:s3:::${each.value}/*",
    ]
  }
}
