#!/usr/bin/env bash
terraform destroy -var-file rancher.tfvars -state rancher.tfstate
