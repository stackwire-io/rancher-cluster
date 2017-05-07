#!/usr/bin/env bash
terraform apply -var-file ${1}.tfvars -state ${1}.tfstate
