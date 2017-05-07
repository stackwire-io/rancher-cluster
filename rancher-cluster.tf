resource "aws_instance" "rancher" {
  count           = "${var.rancher_cluster_size}"
  ami             = "${data.aws_ami.rancher-server.id}"
  instance_type   = "${var.rancher_server_instance_type}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.rancher-server.id}"]
  subnet_id       = "${element(data.aws_subnet_ids.private.ids, count.index)}"
  user_data       = "${data.template_file.rancher-install.rendered}"

  tags {
    Name = "rancher-server"
  }
}

resource "aws_security_group" "rancher-server" {
  name        = "rancher-server"
  description = "Allow outbound to all, inbound on 8080 from ELB, HA inbound on 9345"
  vpc_id      = "${data.aws_vpc.vpc.id}"
}

resource "aws_security_group_rule" "rancher-server-elb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.rancher-server.id}"
  source_security_group_id = "${aws_security_group.elb.id}"
}

resource "aws_security_group_rule" "rancher-server-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.rancher-server.id}"
  cidr_blocks       = ["${data.aws_vpc.vpc.cidr_block}"]
}

resource "aws_security_group_rule" "rancher-server-ha" {
  type              = "ingress"
  from_port         = 9345
  to_port           = 9345
  protocol          = "tcp"
  security_group_id = "${aws_security_group.rancher-server.id}"
  self              = true
}

resource "aws_security_group_rule" "rancher-server-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.rancher-server.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
