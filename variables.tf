variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret access key"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "acm_ssl_cert_arn" {
  description = "The AWS ARN of the SSL certificate to use in ACM"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "environment" {
  description = "The name of the environment"
}

variable "zone_id" {
  description = "Route53 Zone ID"
}

variable "master_hostname" {
  description = "The hostname of the Rancher server (eg. rancher)."
}

variable "master_username" {
  description = "The username to use for the Rancher MySQL database"
}

variable "multi_az" {
  description = "Whether you want your database to be configured as Multi-AZ"
  default = false
}

variable "rancher_server_version" {
  description = "The version of the Rancher server to use"
  default     = "v1.6.0"
}

variable "rancher_server_instance_type" {
  description = "The AWS instance type for the Rancher server"
  default     = "t2.medium"
}

variable "db_server_instance_type" {
  description = "The AWS instance type for the Rancher RDS server"
  default     = "db.t2.micro"
}

variable "rancher_cluster_size" {
  description = "The number of rancher servers to run"
  default     = 3
}
