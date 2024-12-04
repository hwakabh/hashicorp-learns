// https://developer.hashicorp.com/vault/docs/configuration/ui
ui = true
log_level = "debug"

// https://developer.hashicorp.com/vault/docs/configuration/listener/tcp
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true
}

seal "gcpckms" {
  credentials = "/vault/config/vault-unseal.key.json"
  project     = "hc-73563a2f5f734d58b01b501d5aa"
  region      = "global"
  key_ring    = "vault-ent-subkey"
  crypto_key  = "vault-sub-key"
}

// https://developer.hashicorp.com/vault/docs/configuration/storage/filesystem
storage "file" {
  path = "/vault/file"
}
