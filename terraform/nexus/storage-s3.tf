resource "nexus_blobstore_s3" "s3" {
  name = "s3"

  bucket_configuration {
    bucket {
      name       = var.s3.bucket
      region     = "us-east-1" # TODO: should be "vn-hanoi-1"
      expiration = -1
    }

    bucket_security {
      access_key_id     = var.s3.access_key
      secret_access_key = var.s3.secret_key
    }

    advanced_bucket_connection {
      endpoint         = var.s3.endpoint
      signer_type      = "DEFAULT"
      force_path_style = true
    }
  }
}
