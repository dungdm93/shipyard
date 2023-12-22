terraform {
  required_version = ">= 1.2"

  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "~> 1.5"
    }
  }
}

provider "minio" {
  minio_server = var.minio.url
  minio_access_key = var.minio.access_key # env.MINIO_ACCESS_KEY
  minio_secret_key = var.minio.secret_key # env.MINIO_SECRET_KEY
}

variable "minio" {
  description = "minio provider configurations"
  type = object({
    url      = string
    access_key = string
    secret_key = string
  })
}
