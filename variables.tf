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

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "vpc_id" {
  description = "The ID of the VPC to build infrastructure in"
}

variable "public_subnets" {
  description = "A list of IDs for the public subnets within the VPC"
}

variable "private_subnets" {
  description = "A list of IDs for the private subnets within the VPC"
}

variable "zone_id" {
  description = "Route53 Zone ID"
}

variable "master_hostname" {
  description = "The full hostname of the Rancher server. Must exist within the Route53 zone"
}

variable "master_username" {
  description = "The username to use for the Rancher MySQL database"
}

variable "master_password" {
  description = "The password to use for the Rancher MySQL database"
}

variable "ssl_base_name" {
  description = "The base filename of the SSL certificate. Will look for files with .cer & .key"
}

variable "rancher_server_version" {
  description = "The version of the Rancher server to use"
  default     = "v1.3.1"
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
