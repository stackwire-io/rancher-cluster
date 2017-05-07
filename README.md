# Rancher HA with Terraform

This is Terraform code to bring up a fully HA Rancher environment.

## What's "Rancher"?

Rancher is an open source container orchestration tool, meaning that it will make it very easy to deploy containerized applications on bare hardware as well as the major cloud providers. Please visit them here: http://rancher.com/

## How do I use it?

First, you'll need the latest version of Terraform. If you're on a Mac and you have Homebrew installed, start with opening a terminal window and typing

```shell
brew install terraform
```

If not, visit https://terraform.io and download it for your platform.

This code requires you to have already created a VPC using our VPC terraform repository here: https://github.com/stackwire-io/vpc.git

This will create a VPC, internet gateway, NAT gateways and public/private subnets and tag them so that they can be found dynamically. You will also need to create an SSL certificate in AWS cert manager.

Once your VPC has been created, copy the rancher.tfvars.example as rancher.tfvars and fill in the values. For `environment` use the same environment specified in the VPC configs. This is how the VPC & subnet IDs are located.

Run the plan command:

```shell
./plan.sh rancher
```

This will show you what Terraform will do when you run it for real. If you see any errors, correct them and try again.

When it looks right, run apply:

```shell
./apply.sh rancher
```

In a few minutes, you will have a fully working Rancher HA environment that's ready to run containerized applications. It will take a little while for the instances to spin up, install Docker and launch Rancher. It should be reachable via https://{master_hostname} in the domain specified by {zone_id}

The first thing you'll want to do is configure authentication since it's configured with no authentication to start. To configure access control: https://docs.rancher.com/rancher/v1.6/en/configuration/access-control/

*NOTE* By default the MySQL RDS instance is not configured for Multi-AZ. If you want your database instance to be highly available, set the `multi_az` variable to `true`.

Thanks to:

- The team at Hashicorp for creating amazing DevOps tools, including Terraform.
- The team at Rancher Labs for making container orchestration amazingly easy.

### License

You are free to use this code for your own needs without restriction.


### Warranty
This code comes with absolutely no warranty, either expressed or implied, and is completely unsupported. This is meant as a starting point to learn Rancher and WILL launch resources in your AWS account. Please read the code and understand what you're launching when you run apply.

We can not be held responsible if this destroys infrastructure or incurs costs. The resources created by this code will cost money, so please be sure to run `./destroy.sh` when you're done.

If you'd like help, we're available to consult. Please reach out to us: https://www.stackwire.io

Copyright © 2017 Stackwire, LLC. All Rights Reserved.
