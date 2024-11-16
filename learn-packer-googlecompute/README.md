# learn-packer-googlecompute
Play with [`packer-plugin-googlecompute`](https://github.com/hashicorp/packer-plugin-googlecompute/tree/main)

Official References:
- <https://developer.hashicorp.com/packer/integrations/hashicorp/googlecompute>

## Prerequisites
Create variables files `*.auto.pkrvars.hcl` first, since Packer will assign values of variables when running `packer build .`.

```shell
% cat >> variables.auto.pkrvars.hcl << EOF
gcp_project_id = "$(gcloud config get project)"
gcp_machine_type = "e2-micro"
EOF
```

Create dedicated service-account for Packer with least permissions.

```shell
# Create service-account for Packer
% gcloud iam service-accounts create packer \
--project=$(gcloud config get project) \
--description="Packer Service Account" \
--display-name="Packer Service Account"

# Enabled as service-account
% gcloud projects add-iam-policy-binding $(gcloud config get project) \
--member="serviceAccount:packer@$(gcloud config get project).iam.gserviceaccount.com" \
--role="roles/iam.serviceAccountUser"

# Bind with IAM roles
% gcloud projects add-iam-policy-binding $(gcloud config get project) \
--member="serviceAccount:packer@$(gcloud config get project).iam.gserviceaccount.com" \
--role="roles/compute.instanceAdmin.v1"
```

Download the credentials of dedicated service-account and set values with `GOOGLE_CREDENTIALS` variables. \
As the credentials file (`*.key.json`) has been gitignored in this repo, but please be sure to keep it secure in case you specified another filename. \
The evaluation order of credentilas in Packer will be noted in [official docs](https://developer.hashicorp.com/packer/integrations/hashicorp/googlecompute#precedence-of-authentication-methods), so refer them for more details.

```shell
% gcloud iam service-accounts keys create packer.keys.json --iam-account="packer@$(gcloud config get project).iam.gserviceaccount.com"
% export GOOGLE_CREDENTIALS="./packer.key.json"
```

## Integrated with HCP Packer Registry
The sources in this repo, the metadata of machine-images built by packer will be uploaded to [HCP Packer Registry](https://developer.hashicorp.com/packer/tutorials/hcp-get-started) by default. \
For this purpose, you also need to set credentials of HCP. \

```shell
% export HCP_CLIENT_ID=${your_hcp_client_id}
% export HCP_CLIENT_SECRET=${your_hcp_client_secret}
```

In case you have still not issued client_id and client_secret of Packer in HCP, please follow [the official documents](https://developer.hashicorp.com/packer/tutorials/hcp-get-started/hcp-push-artifact-metadata), \
or there is [similar ones](../learn-packer-docker/README.md#interactions-with-hcp-packer-registry) in this repository.

## Build images
Since `*.auto.pkrvars.hcl` will be automatically loaded and since packer will detect all files ended with `*.pkr.hcl`, there is nothing to do anymore. \
Just run:

```shell
% packer build .
```

You can see your machine-images in your Google Cloud projects.

```shell
% gcloud compute images list --no-standard-images
````
