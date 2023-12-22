ui = true

### In dev mod, `listen-address` already provided via cli
# listener "tcp" {
#   address = "0.0.0.0:8200"
# }

storage "file" {
  path = "/vault/file"
}
