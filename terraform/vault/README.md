`vault`
=======

## 1. PKI
* `key_bits`: Specifies the number of bits to use for the generated keys
  * `0`: universal default
  * with `key_type=rsa`: allowed values are `2048` (default), `3072`, or `4096`
  * with `key_type=ec` (ECDSA): allowed values are: `224`, `256` (default), `384`, or `521`
  * ignored with `key_type=ed25519`

Reference:
* [Build Your Own Certificate Authority (CA)](https://developer.hashicorp.com/vault/tutorials/secrets-management/pki-engine)
* [cert-manager w/ Vault](https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-cert-manager)
