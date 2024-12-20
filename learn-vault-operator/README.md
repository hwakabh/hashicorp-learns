# learn-vault-operator

<https://developer.hashicorp.com/vault/tutorials/kubernetes/vault-secrets-operator>

1. Install VSO first on kind-cluster via helm

```shell
% kind create cluster

# Install VSO
% helm install vault-secrets-operator hashicorp/vault-secrets-operator --namespace vault-secrets-operator --create-namespace
# (Optional) Save default vaules
% helm show values hashicorp/vault-secrets-operator > vso.default.values.yaml
```

2. Install Vault on kind-cluster via helm, and unseal it

```shell
# Install Vault
% helm install vault-server hashicorp/vault --namespace vault --create-namespace
# (Optional) Save default vaules
% helm show values hashicorp/vault > vault.default.values.yaml

# Unseal
% kubectl -n vault exec -it vault-server-0 -- vault operator init
% kubectl -n vault exec -it vault-server-0 -- vault operator unseal ${unseal_key_1}
% kubectl -n vault exec -it vault-server-0 -- vault operator unseal ${unseal_key_2}
% kubectl -n vault exec -it vault-server-0 -- vault operator unseal ${unseal_key_3}
```

3. Create VaultConnection CR

```shell
% kubectl apply -f vaultconnections.yaml
% kubectl get vaultconnections
% kubectl describe vaultconnections vault-on-kind
```

4. Enable Kubernetes AuthMethod and provide at least `kubernetes_host`

```shell
% kubectl -n vault exec -it vault-server-0 -- /bin/sh

$ vault login ${root_token}

$ vault auth enable -path=k8s kubernetes
$ vault write auth/k8s/config kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443"
```

5. Create Roles
  - If no policies is provided in role creation, `default` policy will be applied
  - So in this case, we need to update `default` policy HCL, because `default` policy has only permission to `cubbyhole/*` engines

```shell
# Create policy for VSO entity
$ cat << EOF | vault policy write vso-readonly -
path "kv2/*" {
  capabilities = ["read", "list"]
}
EOF

# Checks
$ vault policy list
$ vault policy read vso-readonly

# Create roles in auth/k8s with the policy
$ vault write auth/k8s/role/readonly \
bound_service_account_names="default" \
bound_service_account_namespaces="default" \
policies=vso-readonly \
ttl=1h
```

6. Create VaultAuth CR

```shell
% kubectl apply -f vaultauth.yaml
% kubectl get vaultauth
% kubectl describe vaultauth k8s-auth
```

7. Enable kv2 engine and add any test secret data

```shell
# Within Vault Pod
$ vault secrets enable -path=kv2 kv-v2
$ vault kv put -mount kv2/ app-secret DB_PASSWORD='changeme'

# validate
$ vault kv get -mount kv2 app-secret
```

8. Create VaultStaticSecret CR

```shell
% kubectl apply -f vaultstaticsecret-app.yaml
% kubectl get vaultstaticsecrets
% kubectl describe vaultstaticsecrets vault-static-secret-app
```

9. Validate sync from Vault to k8s secret has been done

```shell
% kubectl get secrets
NAME          TYPE     DATA   AGE
db-password   Opaque   2      93s

% kubectl get secrets db-password -o jsonpath='{.data.DB_PASSWORD}' |base64 -d ; echo
changeme

% kubectl get secrets db-password -o jsonpath='{.data}' |jq .
{
  "DB_PASSWORD": "Y2hhbmdlbWU=",
  "_raw": "eyJkYXRhIjp7IkRCX1BBU1NXT1JEIjoiY2hhbmdlbWUifSwibWV0YWRhdGEiOnsiY3JlYXRlZF90aW1lIjoiMjAyNC0xMi0yMFQwNzo1MzozMS4xNTYzNTg1OTVaIiwiY3VzdG9tX21ldGFkYXRhIjpudWxsLCJkZWxldGlvbl90aW1lIjoiIiwiZGVzdHJveWVkIjpmYWxzZSwidmVyc2lvbiI6MX19"
}

# Same as responses of Vault REST-API
% kubectl get secrets db-password -o jsonpath='{.data._raw}' |base64 -d |jq .
{
  "data": {
    "DB_PASSWORD": "changeme"
  },
  "metadata": {
    "created_time": "2024-12-20T07:53:31.156358595Z",
    "custom_metadata": null,
    "deletion_time": "",
    "destroyed": false,
    "version": 1
  }
}
```
