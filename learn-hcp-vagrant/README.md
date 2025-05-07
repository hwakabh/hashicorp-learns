# learn-hcp-vagrant

## Build Box from Scratch
In case you would like to create source VMs on your desktop hypervisor (such as VMware Fusion/Workstation or Oracle VirtualBox),
just download ISO image from the Internet, and create your VM.

Here is the example of VMware Fusion with Alpine Linux:

```shell
# Download ISO
% wget https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/aarch64/alpine-standard-3.20.3-aarch64.iso
```

Compose with Box format. \
Please refer more details for [official documents](https://developer.hashicorp.com/vagrant/docs/boxes/format).
```shell
% tar czvf alpine.base.box ./metadata.json -C ./src/ .
```

Then you can try scratched box into your Vagrant.
```shell
% vagrant box add --name base-apline ./alpine.base.box

# Validate
% vagrant box list
base-alpine         (vmware_desktop, 0)
```

## multi-machine/multi-provider

```shell
# Prerequired by Vagrant files
# - for mysql container
% export MYSQL_ROOT_PASSWORD="your_password_for_dev"
# - for apline VM (confirm box had been created with above)
% ls -al ./alpine.base.box

# Bringing them up at the same time
% vagrant up
```

## Publish your boxes to HCP Vagrant

- Create service-principals for Vagrant
- Bind roles for service-principal
- Authenticate and publish

```shell
# Add client_id/secret of service-principals for Vagrant
% export HCP_CLIENT_ID="***"
% export HCP_CLIENT_SECRET="***"

# Login to HCP Vagrant Registry
% vagrant cloud auth login
% vagrant cloud auth whoami
Currently logged in as service vagrant

# Confirm that registry has been created before pushing box
% export REGISTRY_NAME="hwakabh"

% vagrant cloud publish $REGISTRY_NAME/alpine 0.1.0 vmware_desktop ./alpine.base.box --force
You are about to publish a box on Vagrant Cloud with the following options:
hwakabh/alpine:   (v0.1.0) for provider 'vmware_desktop'
Box Architecture:      arm64
Saving box information...
Uploading provider with file /Users/hwakabh/git/hashicorp-learns/learn-hcp-vagrant/alpine.base.box
Complete! Published hwakabh/alpine
Box:                  hwakabh/alpine
Private:              no
Version:              0.1.0
Provider:             vmware_desktop
Architecture:         arm64
Default Architecture: yes
```
