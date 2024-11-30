# setup-google-cloud
Terraform Codes for preparing Google Cloud environments with TFC (Terraform Cloud).

## Prerequisites
Since `*.tfvars` files are gitignored for avoiding pushing sensitive data to repository, \
we need to provide required data as Terraform Variables in TFC.
- `google_cloud_project_id`
- `google_cloud_region`
- `google_cloud_zone`
- `gke_num_nodes`
- `gke_cluster_name`
- `gke_network_prefix`
- `gke_subnet_cidr`

Also, some additional variables will be required to be provided as Environmental Variables, not as Terraform Variables, \
depending on your configurations/features in TFC.


## General IAM Configuration
For general use of TFC with Google Cloud, need to create dedicated Service Account for Terraform.

```shell
% export YOUR_GCP_PROJECT=$(gcloud config get project)
% export YOUR_PROJECT_NUMBER=$(gcloud projects list --filter=${YOUR_GCP_PROJECT} --format="value(PROJECT_NUMBER)")

# Create dedicated IAM service-account
% gcloud iam service-accounts create terraform \
--project ${YOUR_GCP_PROJECT} \
--description "TFC Service Account" \
--display-name "TFC Service Account"
# ...

# Add IAM roles to dedicated service-account
% gcloud projects add-iam-policy-binding ${YOUR_GCP_PROJECT} \
--member="serviceAccount:terraform@${YOUR_GCP_PROJECT}.iam.gserviceaccount.com" \
--role=roles/container.admin
# ...

% gcloud projects add-iam-policy-binding ${YOUR_GCP_PROJECT} \
--member="serviceAccount:terraform@${YOUR_GCP_PROJECT}.iam.gserviceaccount.com" \
--role=roles/compute.networkAdmin
# ...

% gcloud projects add-iam-policy-binding ${YOUR_GCP_PROJECT} \
--member="serviceAccount:terraform@${YOUR_GCP_PROJECT}.iam.gserviceaccount.com" \
--role=roles/iam.serviceAccountUser
```

If you would not use Dynamic Provider Credentials, as described in the following sections, you can use Credentials of service-account with setting as TFC environment variables, `GOOGLE_CREDENTIALS`.
Since TFC environmental variables do not allow including line break, need to parse:

```shell
# Generate keys and download credential file of TFC service-account
% gcloud iam service-accounts keys create terraform-sa.keys.json \
--iam-account="terraform@${YOUR_GCP_PROJECT}.iam.gserviceaccount.com"

# Parse JSON
% cat terraform-sa.keys.json |jq -c .
```


## DPC: Dynamic Provider Credentials
For enabling DPC, need to configure on Google Cloud side:
- Create Identity Pool Provider
- Add Attribute Mappings to Identity Pool Provider
- Update IAM role for service-account

```shell
# Create Identity Pool
% gcloud iam workload-identity-pools create tfc-dpc-pools \
--location=global \
--description="Identity Pools for TFC"

# Create OIDC Identity Pool Providers with attributes mappings
% attr=$(cat << EOF |tr -d '\n'
google.subject=assertion.sub,
attribute.aud=assertion.aud,
attribute.terraform_full_workspace=assertion.terraform_full_workspace,
attribute.terraform_organization_id=assertion.terraform_organization_id,
attribute.terraform_organization_name=assertion.terraform_organization_name,
attribute.terraform_project_id=assertion.terraform_project_id,
attribute.terraform_project_name=assertion.terraform_project_name,
attribute.terraform_run_id=assertion.terraform_run_id,
attribute.terraform_run_phase=assertion.terraform_run_phase,
attribute.terraform_workspace_id=assertion.terraform_workspace_id,
attribute.terraform_workspace_name=assertion.terraform_workspace_name
EOF
)

# Create OIDC Provider with providing Custom Attribute mappings/CEL (allowed from any TFC workspace)
# Note that TFC Org/Project name should be changed per each configuration
% gcloud iam workload-identity-pools providers create-oidc tfc-oidc-provider \
--project="${YOUR_GCP_PROJECT}" \
--location="global" \
--workload-identity-pool="tfc-id-pool" \
--display-name="tfc-oidc-provider" \
--description="OIDC Provider for TFC" \
--issuer-uri="https://app.terraform.io" \
--attribute-condition="assertion.sub.startsWith(\"organization:hwakabh-test:project:default-terraform-project:workspace:\")" \
--attribute-mapping="$attr"

# Add IAM policy bindings
% gcloud iam service-accounts add-iam-policy-binding terraform@${YOUR_GCP_PROJECT}.iam.gserviceaccount.com \
--member="principalSet://iam.googleapis.com/projects/${YOUR_PROJECT_NUMBER}/locations/global/workloadIdentityPools/tfc-id-pool/*" \
--role="roles/iam.workloadIdentityUser"

% gcloud projects add-iam-policy-binding ${YOUR_GCP_PROJECT} \
--member="serviceAccount:terraform@${YOUR_GCP_PROJECT}.iam.gserviceaccount.com" \
--role=roles/iam.serviceAccountTokenCreator

# If just operating `terraform plan` only, we need not to bind editor roles
% gcloud projects add-iam-policy-binding ${YOUR_GCP_PROJECT} \
--member="serviceAccount:terraform@${YOUR_GCP_PROJECT}.iam.gserviceaccount.com" \
--role=roles/editor
```

After all the required resources created in Google Cloud side, need to add values for:
- `TFC_GCP_PROVIDER_AUTH`
  - value: `true`
  - for enabling DPC features
- `TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL`
  - value: `terraform@${YOUR_GCP_PROJECT}.iam.gserviceaccount.com`
  - service-account emails which TFC will use to provision GKE cluster
- `TFC_GCP_WORKLOAD_PROVIDER_NAME`
  - value: `/projects/${YOUR_PROJECT_NUMBER}/locations/global/workloadIdentityPools/tfc-id-pool`
  - OIDC Provider information to issue temporary token
