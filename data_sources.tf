/* Find the latest Ubuntu Xenial AMI for our region */
data "aws_ami" "rancher-server" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

/* The user-data script used to configure the Rancher server */
data "template_file" "rancher-install" {
  template = "${file("install.sh")}"

  vars {
    rancher_version = "${var.rancher_server_version}"
    db_host         = "${aws_db_instance.rancher.address}"
    db_port         = "${aws_db_instance.rancher.port}"
    db_user         = "${var.master_username}"
    db_password     = "${var.master_password}"
  }
}

/* Give us access to the VPC that we're configured for */
data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}
