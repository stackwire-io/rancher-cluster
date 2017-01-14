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

/* Inbound 3306 from Rancher Server */
resource "aws_security_group" "mysql-server" {
  name        = "rancher-mysql-server"
  description = "Allow inbound on 3306 from rancher servers"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.rancher-server.id}"]
  }
}
