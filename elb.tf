resource "aws_elb" "rancher" {
  name            = "${var.environment}-rancher-elb"
  security_groups = ["${aws_security_group.elb.id}"]
  subnets         = ["${data.aws_subnet_ids.public.ids}"]
  instances       = ["${aws_instance.rancher.*.id}"]

  listener {
    instance_port      = 8080
    instance_protocol  = "tcp"
    lb_port            = 443
    lb_protocol        = "ssl"
    ssl_certificate_id = "${var.acm_ssl_cert_arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/ping"
    interval            = 10
  }
}

resource "aws_proxy_protocol_policy" "websockets" {
  load_balancer  = "${aws_elb.rancher.name}"
  instance_ports = ["8080"]
}

resource "aws_security_group" "elb" {
  name        = "${var.environment}-elb-sg"
  description = "Allow inbound on 443 from the internet"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.vpc.cidr_block}"]
  }
}
