#!/bin/sh

. ./env.sh 

hammer hostgroup delete --name "Coreos dev"

hammer os delete --title "RHCOS 8"

hammer medium delete --name "Red Hat CoreOS" 

hammer template delete --name "Red Hat CoreOS PXELinux"

