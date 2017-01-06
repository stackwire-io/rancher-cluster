#!/usr/bin/env bash
terraform plan -var-file rancher.tfvars -state rancher.tfstate
