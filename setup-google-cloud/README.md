# setup-google-cloud
Terraform Codes for preparing Google Cloud environments with TFC (Terraform Cloud).

## IAM Configuration
For general use of TFC with Google Cloud, need to create dedicated Service Account for Terraform.

```shell
# Create dedicated IAM service-account
% export YOUR_GCP_PROJECT=$(gcloud config get project)
% gcloud iam service-accounts create terraform \
--project $YOUR_GCP_PROJECT \
--description "TFC Service Account" \
--display-name "TFC Service Account"
# ...

# Add IAM roles to dedicated service-account
% gcloud projects add-iam-policy-binding $YOUR_GCP_PROJECT \
--member="serviceAccount:terraform@${YOUR_GCP_PROJECT}.iam.gserviceaccount.com" \
--role="roles/container.admin"
# ...

% gcloud projects add-iam-policy-binding $YOUR_GCP_PROJECT \
--member="serviceAccount:terraform@${YOUR_GCP_PROJECT}.iam.gserviceaccount.com" \
--role=roles/compute.networkAdmin
# ...

% gcloud projects add-iam-policy-binding $YOUR_GCP_PROJECT \
--member="serviceAccount:terraform@${YOUR_GCP_PROJECT}.iam.gserviceaccount.com" \
--role=roles/iam.serviceAccountUser
```

## DPC: Dynamic Provider Credentials
For enabling DPC, need to configure on Google Cloud side:
- Create Identity Pool
- Create Identity Pool Provider
- Add Attribute Mappings to Identity Pool Provider
- Update IAM role for service-account
