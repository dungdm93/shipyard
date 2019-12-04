variable "region" {
  description = "Region for DWH cluster"
  type        = string
  default     = "asia-southeast1"
}

provider "google" {
  project = "teko-warehouse"
  version = "~> 3.0.0-beta.1"
}
