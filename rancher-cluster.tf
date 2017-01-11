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

resource "aws_instance" "rancher" {
  count           = "${var.rancher_cluster_size}"
  ami             = "${data.aws_ami.rancher-server.id}"
  instance_type   = "${var.rancher_server_instance_type}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.rancher-server.id}"]
  subnet_id       = "${element(split(",", var.private_subnets), count.index)}"
  user_data       = "${data.template_file.rancher-install.rendered}"
}

resource "aws_db_instance" "rancher" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7.16"
  instance_class         = "${var.db_server_instance_type}"
  name                   = "rancher"
  username               = "${var.master_username}"
  password               = "${var.master_password}"
  db_subnet_group_name   = "${aws_db_subnet_group.rancher.id}"
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = ["${aws_security_group.mysql-server.id}"]
  storage_type           = "gp2"
}

resource "aws_db_subnet_group" "rancher" {
  name       = "rancher"
  subnet_ids = ["${split(",", var.private_subnets)}"]
}

resource "aws_alb_listener" "rancher" {
  load_balancer_arn = "${aws_alb.rancher.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_iam_server_certificate.rancher-ssl.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.rancher.arn}"
    type             = "forward"
  }
}

resource "aws_alb" "rancher" {
  name            = "rancher-alb"
  internal        = false
  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${split(",", var.public_subnets)}"]
}

resource "aws_alb_target_group" "rancher" {
  name     = "rancher-alb-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb_target_group_attachment" "rancher" {
  count            = "${var.rancher_cluster_size}"
  target_group_arn = "${aws_alb_target_group.rancher.arn}"
  target_id        = "${element(aws_instance.rancher.*.id, count.index)}"
  port             = 8080
}

resource "aws_iam_server_certificate" "rancher-ssl" {
  name             = "rancher-ssl"
  certificate_body = "${file("${var.ssl_base_name}.cer")}"
  private_key      = "${file("${var.ssl_base_name}.key")}"
}

resource "aws_route53_record" "rancher" {
  zone_id = "${var.zone_id}"
  name    = "${var.master_hostname}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_alb.rancher.dns_name}"]
}

resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow inbound on 80 and 443 from anywhere. Outbound on 80 to the rancher server"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rancher-server" {
  name        = "rancher-server-sg"
  description = "Allow outbound to all, inbound on 8080 from ALB"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb.id}"]
    self            = true
  }

  ingress {
    from_port   = 9345
    to_port     = 9345
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "mysql-server" {
  name        = "mysql-server"
  description = "Allow inbound on 3306 from rancher servers"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.rancher-server.id}"]
  }
}
