Vault Manual
============

### Dependencies

1. Ensure K8s pod can access to googleapis.com & has DNS server

2. Create PostgreSQL schema and indexes

    See: https://www.vaultproject.io/docs/configuration/storage/postgresql

3. Create KMS keyring & key. then create service account with proper permissions, get a JSON credentials

    See: https://developer.hashicorp.com/vault/docs/configuration/seal/gcpckms

4. Create `kms-creds` secret:
    ```bash
    kubectl -n vault create secret generic kms-creds \
        --from-file=gcp-credentials.json=/path/to/gcp/credentials.json
    ```

### Steps

1. Deploy Vault Helm release via Gitlab CI

2. Initializes Vault server
    ```bash
    vault operator init
    ```
    It will emit 5 unseal keys & root token. Please save them IN A SECURE PLACE!

3. Unseal Vault
    ```
    # Unseal up to <threshold> times
    vault operator unseal <unseal key 1>
    vault operator unseal <unseal key 2>
    vault operator unseal <unseal key 3>
    ```

4. Configure Vault using [Terraform code](/terraform/vault)
