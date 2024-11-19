# learn-packer-vagrant-integration
The ways to make Boxes for Vagrant

## packer-plugin-vagrant
Using builder/vagrant
<https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/builder/vagrant>

Build Boxes from Base Box, which has been already composed
### Fetch Box from remote location
Base Box: `bento/debian-11`

### Box from local
Base Box: [alpine.box](../learn-hcp-vagrant/README.md)
Also, you can download this box from HCP Vagrant


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
