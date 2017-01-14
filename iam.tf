resource "aws_iam_server_certificate" "rancher-ssl" {
  name             = "rancher-ssl"
  certificate_body = "${file("${var.ssl_base_name}.cer")}"
  private_key      = "${file("${var.ssl_base_name}.key")}"
}
