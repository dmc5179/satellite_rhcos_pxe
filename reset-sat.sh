#!/bin/sh

. ./env.sh 

hammer hostgroup delete --name "Coreos dev"

hammer os delete --title "RHCOS 8"


