#!/bin/bash

# Script to download Red Hat CoreOS and host it on a Red Hat Satellite Server

# Source env vars file
. ./env.sh

mkdir -p /var/www/html/pub/rhcos/amd64-usr/8/
pushd /var/www/html/pub/rhcos/amd64-usr/8/

wget https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/${RHCOS_VERSION:0:-2}/${RHCOS_VERSION}/rhcos-${RHCOS_VERSION}-x86_64-installer-kernel-x86_64

ln -sf rhcos-${RHCOS_VERSION}-x86_64-installer-kernel-x86_64 coreos_production_pxe.vmlinuz

wget https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/${RHCOS_VERSION:0:-2}/${RHCOS_VERSION}/rhcos-${RHCOS_VERSION}-x86_64-installer-initramfs.x86_64.img

ln -sf rhcos-${RHCOS_VERSION}-x86_64-installer-initramfs.x86_64.img coreos_production_pxe_image.cpio.gz

popd

pushd /var/www/html/pub/rhcos

curl -L -O https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/${RHCOS_VERSION:0:-2}/${RHCOS_VERSION}/rhcos-${RHCOS_VERSION}-x86_64-metal.x86_64.raw.gz

ln -s rhcos-${RHCOS_VERSION}-x86_64-metal.x86_64.raw.gz rhcos-metal-bios.raw.gz
