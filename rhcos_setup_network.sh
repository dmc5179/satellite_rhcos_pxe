#!/bin/sh
#
# Break out network setup
#
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


