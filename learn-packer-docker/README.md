# learn-packer-docker
Play with [`packer-plugin-docker`](https://github.com/hashicorp/packer-plugin-docker)

Official tutorial: <https://developer.hashicorp.com/packer/tutorials/docker-get-started>

## Interactions with HCP Packer Registry
For pushing metadata to HCP Packer Registry, we need to do several operations as prerequisites in HCP side.
- Create service-principal for packer
- Add policy bindings for your project
- Generate Keys of packer service-principal

```shell
# Create service-principal on your HCP organization
% hcp iam service-principals create packer
# ...

# Add policy bindings to your project
% hcp projects iam add-binding \
--project=${your_project_id} \
--member=$(hcp iam service-principals read packer --format=json |jq -r .id) \
--role=roles/contributor

# Navigate to HCP Packer via Browser, then generate keys for service-principal `packer`
# -> UI Only, seems not implemented in hcp-cli

# Set Client ID/Secret for accessing HCP Packer Registry
% export HCP_CLIENT_ID=${your_hcp_client_id}
% export HCP_CLIENT_SECRET=${your_hcp_client_secret}
```

## Interact with Container Registry
TBD
