resource "vault_mount" "ssh" {
  path        = "ssh"
  type        = "ssh"
  description = "The Vault SSH secrets engine provides secure authentication and authorization for access to machines via the SSH protocol"
}
