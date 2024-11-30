---
apiVersion: secrets.hashicorp.com/v1beta1
kind: VaultAuth
metadata:
  namespace: default
  name: vault-auth
spec:
  # point to name of VaultConnection CR
  vaultConnectionRef: vault-connection
  method: kubernetes
  mount: kubernetes
  kubernetes:
    # Role on Vault
    role: raadonly
    # k8s SA using to fetch secrets from Vault
    serviceAccount: default
