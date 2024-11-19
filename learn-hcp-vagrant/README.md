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
% tar czvf base.box ./metadata.json -C ./src/ .
```

Then you can try scratched box into your Vagrant.
```shell
% vagrant box add --name basebox ./base.box

# Validate
% vagrant box list
basebox         (vmware_desktop, 0)
```

## multi-machine/multi-provider

```shell
% vagrant up
```

## Publish your boxes to HCP Vagrant

- Create service-principals for Vagrant
- Bind roles for service-principal
- Authenticate and publish
