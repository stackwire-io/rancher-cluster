#!/usr/bin/env bash
terraform plan -var-file ${1}.tfvars -state ${1}.tfstate
