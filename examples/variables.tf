variable "region" {}
variable "my_vpc_cidr" {}
variable "my_vpc_name" {}
variable "my_vpc_private_subnet_cidrs" {
  type = "list"
}
variable "my_vpc_private_restricted_cidrs" {
  type = "list"
}
variable "my_vpc_public_subnet_cidrs" {
  type = "list"
}

variable "tags" {
  type = "map"
}
