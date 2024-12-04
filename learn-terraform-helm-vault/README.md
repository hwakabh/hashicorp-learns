# setup-vault-gke
Codes for provisioning Vault HA cluster onto GKE cluster.

```shell
.
├── docker-compose    # for local environment using Docker Desktop
└── helm              # manual installations using helm-cli
```

## Enterprise License

- Create Kubernetes secret resources storing licenses by `kubectl` from local

https://developer.hashicorp.com/vault/docs/platform/k8s/helm/enterprise

```shell
% kubectl create ns vault

% LICENSE_STRING=$(cat ./vault-enterprise.hclic)
% kubectl -n vault create secret generic vault-ent-license --from-literal="license=${LICENSE_STRING}"
```


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
$ gcloud iam service-accounts create vault-deploy \
--project $(gcloud config get project) \
--description "Vault Service Account to deploy" \
--display-name "Vault Service Account to deploy"

# add IAM policy bindings for provisioning Vault Cluster on GKE
% gcloud projects add-iam-policy-binding $(gcloud config get project) \
--role="roles/iam.serviceAccountUser" \
--member="serviceAccount:vault-deploy@$(gcloud config get core/project).iam.gserviceaccount.com"

% gcloud projects add-iam-policy-binding $(gcloud config get project) \
--member="serviceAccount:vault-deploy@$(gcloud config get core/project).iam.gserviceaccount.com" \
--role="roles/container.admin"

% gcloud projects add-iam-policy-binding $(gcloud config get project) \
--member="serviceAccount:vault-deploy@$(gcloud config get core/project).iam.gserviceaccount.com" \
--role="roles/compute.networkAdmin"

# add IAM policy bindings for DPC
% gcloud iam service-accounts add-iam-policy-binding vault-deploy@$(gcloud config get core/project).iam.gserviceaccount.com \
--member="principalSet://iam.googleapis.com/projects/$(gcloud projects list --filter=$(gcloud config get core/project) --format="value(PROJECT_NUMBER)")/locations/global/workloadIdentityPools/tfc-id-pool/*" \
--role="roles/iam.workloadIdentityUser"

% gcloud projects add-iam-policy-binding $(gcloud config get project) \
--member="serviceAccount:vault-deploy@$(gcloud config get core/project).iam.gserviceaccount.com" \
--role="roles/iam.workloadIdentityUser"

% gcloud projects add-iam-policy-binding $(gcloud config get project) \
--member="serviceAccount:vault-deploy@$(gcloud config get core/project).iam.gserviceaccount.com" \
--role="roles/iam.serviceAccountTokenCreator"
```

Then we need to set environmental variables in HCP Terraform to enabling DPC.
- `TFC_GCP_PROVIDER_AUTH`
- `TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL`
- `TFC_GCP_WORKLOAD_PROVIDER_NAME`


## Configurations for Auto unseal with Cloud KMS

```shell
# Enable Cloud KMS API, which is disabled by default
$ gcloud services enable cloudkms.googleapis.com --project=$(gcloud config get core/project)

# Create dedicated service-account for auto-unseal
% gcloud iam service-accounts create vault-kms \
--project $(gcloud config get project) \
--description "Vault Enterprise Service Account" \
--display-name "Vault Enterprise Service Account"

% gcloud projects add-iam-policy-binding $(gcloud config get project) \
--role="roles/iam.serviceAccountUser" \
--member="serviceAccount:vault-kms@$(gcloud config get core/project).iam.gserviceaccount.com"

# Create keyrings & encrypt-key and bind service-account as owner
% gcloud kms keyrings create vault-ent-cloudkeys --location=global
% gcloud kms keys create vault-crypto-key --location=global --keyring=vault-ent-cloudkeys --purpose="encryption"
% gcloud kms keyrings add-iam-policy-binding vault-ent-cloudkeys --location=global \
--member="serviceAccount:vault-kms@$(gcloud config get project).iam.gserviceaccount.com" \
--role="roles/owner"

# Generate credentials and download to store as kubernetes secret
% gcloud iam service-accounts keys create vault-kms.key.json \
--iam-account=vault-kms@$(gcloud config get project).iam.gserviceaccount.com
```

Check downloaded credential files and create kubernetes secrets from it. \
Be sure that we need to expose this credential files as public.

```shell
% kubectl -n vault create secret generic vault-kms-credentials --from-file=vault-unseal.key.json
```
