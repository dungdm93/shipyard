terraform {
  required_version = ">= 0.14"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.20.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare.api_token # env.CLOUDFLARE_API_TOKEN
}

variable "cloudflare" {
  description = "Cloudflare provider configurations"
  type = object({
    api_token  = string
    account_id = string
  })
}
