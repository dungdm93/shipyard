terraform {
  required_version = ">= 0.14"

  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.18"
    }
  }
}

provider "postgresql" {
  host     = var.postgresql.host
  port     = var.postgresql.port
  sslmode  = "disable"
  username = var.postgresql.username
  password = var.postgresql.password
}

variable "postgresql" {
  description = "PostgreSQL provider configurations"
  type = object({
    host     = string
    port     = number
    username = string
    password = string
  })
}

output "accounts" {
  value = merge(
    {
      for account in postgresql_role.users :
      account.name => account.password
    },
    {
      for account in postgresql_role.users_readonly :
      account.name => account.password
    }
  )
  sensitive = true
}
