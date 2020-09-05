#!/bin/bash



pushd /var/lib/tftpboot/boot/

wget https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.5/4.5.6/rhcos-4.5.6-x86_64-installer-kernel-x86_64

ln -sf rhcos-4.5.6-x86_64-installer-kernel-x86_64 rhcos-installer-kernel

wget https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.5/4.5.6/rhcos-4.5.6-x86_64-installer-initramfs.x86_64.img

ln -sf rhcos-4.5.6-x86_64-installer-initramfs.x86_64.img rhcos-installer-initramfs.img

popd


mkdir -p /var/www/html/pub/rhcos

pushd /var/www/html/pub/rhcos

curl -L -O https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.5/4.5.6/rhcos-4.5.6-x86_64-metal.x86_64.raw.gz

ln -s rhcos-4.5.6-x86_64-metal.x86_64.raw.gz rhcos-metal-bios.raw.gz

# Create Empty Partition Table
hammer partition-table create --name 'rhcos_empty' \
  --description 'Emptry partition table for RHCOS' \
  --os-family 'Coreos' --locked true \
  --organization 'Red Hat ICSA Team' \
  --file rhcos_partition.txt

# Create Installation Media
hammer medium create --name 'rhcos_empty' \
  --organization 'Red Hat ICSA Team' \
  --path 'http://stargazer.icsa.iad.redhat.com/pub/rhcos' \
  --os-family 'Coreos'

# Create the Operating System
hammer os create --name 'RHCOS' \
  --organization 'Red Hat ICSA Team' \
  --major '8' --family 'Coreos' \
  --password-hash 'SHA256' \
  --architectures 'x86_64' \
  --partition-tables 'rhcos_empty' \
  --media 'rhcos_empty'
