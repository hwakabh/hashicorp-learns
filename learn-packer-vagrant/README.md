# learn-packer-vagrant-integration
The ways to make Boxes for Vagrant

## packer-plugin-vagrant
Using builder/vagrant
<https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/builder/vagrant>

Build Boxes from Base Box, which has been already composed. \
There are mainly 2 options to prepare base box on your machine.
### Fetch Box from remote location
Base Box: `bento/debian-11` \
Note that `architecture` of box will be determined by the one of [`packer` binaries](https://developer.hashicorp.com/packer/install).
- If you are using `AMD64` packer, the architecture of box will be `amd64`
- Else you are using `ARM64` packer, the architecture of box will be `arm64`

Be sure that your `packer` binaries is installed with proper architecture on your machine, and note that if there might be ignored (with such as Apple Rosseta) \
the `vagrant up` will failed because of architecture mismatching between downloaded boxes and CPU architecture.

```shell
% packer build -only=vagrant.cloudbox .
```

### Box from local
Base Box: [alpine.base.box](../learn-hcp-vagrant/README.md) \
Of course, `alpine.base.box` has been stored as public box in HCP Vagrant, \
so you can download this instead of building from scratch with shorthanded name `hwakabh/base-alpine`.

Note that this `alpine.base.box` had been build on Apple Silicon environment, so you need to build box from scratch on your machine \
in case you has the machines with other CPU architecture.

```shell
% packer build -only=vagrant.localbox .
```

## packer-plugin-vmware
Using builder/vmware-iso
<https://developer.hashicorp.com/packer/integrations/hashicorp/vmware/latest/components/builder/iso>

Build Box from ISO


## Integrate with HCP Vagrant
Using post-processor/vagrant-registry in `packer-plugin-vagrant`
<https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant-registry>


## Convert to Boxes
Using post-processor/vagrant
<https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant>

```shell
% packer build -only=docker.nginx .
```
