#!/bin/sh

. ./env.sh 

hammer hostgroup delete --name "Coreos dev"

hammer os delete --title "RHCOS 8"

<<<<<<< HEAD
hammer medium delete --name "Red Hat CoreOS" 

hammer template delete --name "Red Hat CoreOS PXELinux"
=======
>>>>>>> 1d3cfb5b5d61f820b5920c93c3b8050f99c47a96

