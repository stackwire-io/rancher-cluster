#!/usr/bin/env bash
terraform destroy -var-file ${1}.tfvars -state ${1}.tfstate
