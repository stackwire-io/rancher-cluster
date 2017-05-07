resource "aws_route53_record" "rancher" {
  zone_id = "${var.zone_id}"
  name    = "${var.master_hostname}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elb.rancher.dns_name}"]
}
