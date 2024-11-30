// https://developer.hashicorp.com/vault/docs/configuration/ui
ui = true
log_level = "debug"

// https://developer.hashicorp.com/vault/docs/configuration/listener/tcp
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true
}

// multi-seal setup + Cloud Keys
// https://developer.hashicorp.com/vault/docs/configuration/seal/seal-ha
// https://developer.hashicorp.com/vault/docs/configuration/seal/gcpckms
enable_multiseal = true

seal "gcpckms" {
  name        = "gcpckms-primary"
  priority    = "1"
  credentials = "/vault/config/vault-unseal.key.json"
  project     = "hc-8732d2178369440c886cb59aee6"
  region      = "global"
  key_ring    = "vault-ent-cloudkeys"
  crypto_key  = "vault-crypto-key"
}

seal "gcpckms" {
  name        = "gcpckms-secondary"
  priority    = "2"
  credentials = "/vault/config/vault-unseal.key.json"
  project     = "hc-8732d2178369440c886cb59aee6"
  region      = "global"
  key_ring    = "vault-ent-subkey"
  crypto_key  = "vault-sub-key"
}


// https://developer.hashicorp.com/vault/docs/configuration/storage/filesystem
storage "file" {
  path = "/vault/file"
}
