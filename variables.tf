variable "vpc_name" {}
variable "vpc_cidr" {}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
variable "region" {}
variable "cluster_name" {}
variable "cluster_version" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "node_instance_type" {}
variable "enable_autoscaler" {}
variable "ecr_repo_name" {}
variable "ecr_scan_on_push" {}
variable "repository_lifecycle_policy" {}
variable "tags" {
  type = map(string)
}
