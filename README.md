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

Next, copy the `rancher.tfvars.example` to `rancher.tfvars` and fill in the values. The file is documented, so just add the required values.

You will need an SSL certificate (use Let's Encrypt - they're free!) for {master_hostname}. So, for example, if my {master_hostname} was set to rancher.stackwire.io, I would get an SSL certificate for rancher.stackwire.io. Put the certificate and keys in this directory and name them {ssl_base_name}.cer and {ssl_base_name}.key
You will need an existing VPC with public and private subnets. You could also use your AWS account's default VPC and use the public subnet IDs for both public and private subnet variables.

Run the plan command:

```shell
./plan.sh
```

This will show you what Terraform will do when you run it for real. If you see any errors, correct them and try again.

When it looks right, run apply:

```shell
./apply.sh
```

In a few minutes, you will have a fully working Rancher HA environment that's ready to run containerized applications. It will take a little while for the instances to spin up, install Docker and launch Rancher. It should be reachable via https://{master_hostname}

The first thing you'll want to do is configure authentication since it's configured with no authentication to start. To configure access control: http://docs.rancher.com/rancher/v1.3/en/configuration/access-control/

*NOTE* This is not really production ready since the database is not configured for Multi-AZ, but it can easily be converted to Multi-AZ by changing the aws_db_instance resource.

Thanks to:

- The team at Hashicorp for creating amazing DevOps tools, including Terraform.
- The team at Rancher Labs for making container orchestration amazingly easy.

### Warranty
This code comes with absolutely no warranty, either expressed or implied, and is completely unsupported. This is meant as a starting point to learn Rancher and WILL launch resources in your AWS account. Please read the code and understand what you're launching when you run apply.

We can not be held responsible if this destroys infrastructure or incurs costs. The resources created by this code will cost money, so please be sure to run `./destroy.sh` when you're done.

If you'd like help, we're available to consult. Please reach out to us: https://www.stackwire.io

Copyright © 2017 Stackwire, LLC. All Rights Reserved.
