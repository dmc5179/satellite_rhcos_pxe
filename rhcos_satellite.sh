#!/bin/bash


# Source env vars file
. env.sh

# TODO: Need to create a subnet with associated TFTP capsule
hammer subnet --name icsa \
  --description "icsa" \
  --boot-mode 'DHCP' \
  --dns-primary '10.15.169.20' \
  --domains 'icsa.iad.redhat.com' \
  --gateway '10.15.169.254' \
  --organization 'Red Hat ICSA Team' \
  --location "Tyson's Corner Lab" \
  --mask '255.255.255.0' \
  --mtu '9000' \
  --network-type 'IPv4' \
  --tftp 'stargazer.icsa.iad.redhat.com'

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

# PXE Template
hammer template create --name 'rhcos_pxe' \
  --organization 'Red Hat ICSA Team' \
  --description 'PXE template for RHCOS' \
  --operatingsystems 'RHCOS 8' \
  --type 'PXELinyx' \
  --file rhcos_pxe_template.txt

# Empty Provisioning Template
hammer template create --name 'rhcos_prov' \
  --organization 'Red Hat ICSA Team' \
  --description 'Provisioning template for RHCOS' \
  --operatingsystems 'RHCOS 8' \
  --type 'provision' \
  --file rhcos_prov_template.txt

# Get OS ID
OS_ID=$(hammer --no-headers os list --os-parameters-attributes "name=family\,value=Coreos" | grep 'RHCOS 8' | awk -F\  '{print $1}')

# Set PXE and Provisioning Templates for new OS
hammer os update --id ${OS_ID} \
  --major '8' --family 'Coreos' \
  --provisioning-templates 'rhcos_pxe,rhcos_prov'

# TODO: This doesn't quite work. It seems the templates are not config templates?
#       Without this setting the defaults are not set. Not sure if PXE will work without them
#hammer os 'set-default-template' --id ${OS_ID} \
#  --config-template-id 'rhcos_pxe,rhcos_prov'

# Create the bootstrap host
hammer host create --name "bootstrap-${OCP_CLUSTER_NAME}" \
  --organization 'Red Hat ICSA Team' \
  --location "Tyson's Corner Lab'" \
  --deploy-on 'Bare Metal' \
  --mac '' \
  --operating-system-id ${OS_ID} \
  --architecture 'x86_64' \
  --media '' \
  --partition-table '' \
  --pxe-loader '' \
  --build '' \
  --interfaces
