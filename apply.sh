#!/usr/bin/env bash
terraform apply -var-file rancher.tfvars -state rancher.tfstate
