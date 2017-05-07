resource "aws_alb_listener" "rancher" {
  load_balancer_arn = "${aws_alb.rancher.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.acm_ssl_cert_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.rancher.arn}"
    type             = "forward"
  }
}

resource "aws_alb" "rancher" {
  name            = "rancher-alb"
  internal        = false
  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${data.aws_subnet_ids.public.ids}"]
}

resource "aws_alb_target_group" "rancher" {
  name     = "rancher-alb-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.vpc.id}"
}

resource "aws_alb_target_group_attachment" "rancher" {
  count            = "${var.rancher_cluster_size}"
  target_group_arn = "${aws_alb_target_group.rancher.arn}"
  target_id        = "${element(aws_instance.rancher.*.id, count.index)}"
  port             = 8080
}

/* Inbound 80/443 from world. Used on ALB */
resource "aws_security_group" "alb" {
  name        = "rancher-alb"
  description = "Allow inbound on 80 and 443 from anywhere. Outbound on 8080 to the rancher server"
  vpc_id      = "${data.aws_vpc.vpc.id}"
}

resource "aws_security_group_rule" "alb-ingress-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.alb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb-egress-rancher-server" {
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.alb.id}"
  source_security_group_id = "${aws_security_group.rancher-server.id}"
}
