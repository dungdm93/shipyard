variable "credentials" {
  description = "Either the path to or contents of a ServiceAccount key file in JSON format"
  type        = string
}

provider "google" {
  credentials = "${var.credentials}"
  project     = "teko-warehouse"
  version     = "~> 3.0.0-beta.1"
}
