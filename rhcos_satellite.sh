#!/bin/bash


# Source env vars file
. ./env.sh

# Set up network
# . ./rhcos_setup_network.sh

# 
# Sets up OS assuming that network stuff is already set up
#

# Create the media
hammer medium create --name "Red Hat CoreOS" \
  --organization "$ORG" \
  --path "http://localhost/pub/rhcos" \
  --os-family "Coreos"

# Create the Operating System
hammer os create --name 'RHCOS' \
  --organization "$ORG" \
  --major '8' --family 'Coreos' \
  --password-hash 'SHA256' \
  --architectures 'x86_64' \
  --partition-tables 'CoreOS default fake' \
  --media 'Red Hat CoreOS'

# Create new PXELinux file
hammer template create --name 'Red Hat CoreOS PXELinux' \
  --file 'rhcos_pxe_template.txt' \
  --operatingsystems 'RHCOS 8' \
  --type 'PXELinux' \
  --location "$LOC" \
  --organization "$ORG"

# Get OS ID
OS_ID=$(hammer --no-headers os list --search "family=Coreos" --fields "id")

for TMPL in 'Red Hat CoreOS PXELinux' 'CoreOS provision'
do

	# Associate already existing templates to Operating System
	hammer template add-operatingsystem --name "$TMPL" \
	   --operatingsystem-id "$OS_ID"

	# Set Template for new OS
	hammer os add-config-template --config-template "$TMPL" \
	  --id "$OS_ID" \

	# Add template as default for that type
	TMPL_ID=$(hammer template info --name "$TMPL" --fields id | awk '{print $2; exit}')
	hammer os set-default-template --id "$OS_ID" --config-template-id "$TMPL_ID" 

done

hammer hostgroup create --name "Coreos dev" \
  --compute-resource "$COMPUTE_RESOURCE" \
  --compute-profile "$COMPUTE_PROFILE" \
  --domain "$DOMAIN"  \
  --subnet "Private"  \
  --operatingsystem "RHCOS 8" \
  --architecture "x86_64" \
  --medium "Red Hat CoreOS" \
  --partition-table "CoreOS default fake" \
  --pxe-loader "PXELinux BIOS" \
  --location "$LOC" \
  --organization "$ORG"

hammer host create --name "$SVRNAME" \
  --hostgroup "Coreos dev" \
  --location "$LOC" \
  --organization "$ORG"

# Start up VM 
hammer host start --name "${SVRNAME}.$DOMAIN" 


