# setup-vault-gke
Codes for provisioning Vault HA cluster onto GKE cluster.

```shell
.
├── docker-compose    # for local environment using Docker Desktop
└── helm              # manual installations using helm-cli
```

## Enterprise License

- Create Kubernetes secret resources storing licenses by `kubectl` from local


## Configurations for DPC
In order to use Dynamic Provider Credentials (DPC) for `terraform-provider-google` to get information where Vault cluster would be deployed, \
we need to create Identity Pool and its OIDC Provider as Google Cloud resources.

```shell
# TBU
% gcloud iam workload-identity-pools list --location global
```

Create service-account with sufficient IAM policies to provision Vault Cluster on GKE cluster.
(We can use same service-account used in another Terraform workspaces [`setup-google-cloud`](../setup-google-cloud/))

```shell
# create dedicated service-account only for provisioning Vault Cluster

# add IAM policy bindings for provisioning Vault Cluster on GKE
```

Then we need to set environmental variables in HCP Terraform to enabling DPC.
- `TFC_GCP_PROVIDER_AUTH`
- `TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL`
- `TFC_GCP_WORKLOAD_PROVIDER_NAME`


## Configurations for Auto unseal with Cloud KMS

- Create keyrings
- Generate encrypt-key with keyrings
- Create dedicated service-account for referring Cloud KMS keyrings
- Bind required IAM policy bindings for the service-account
- Create Kubernetes secret resource by `kubectl` from local (for security)
