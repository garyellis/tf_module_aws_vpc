variable "region" {}
variable "my_vpc_cidr" {}
variable "my_vpc_name" {}
variable "my_vpc_private_subnet_cidrs" {
  type = list(map(string))
}
variable "my_vpc_private_restricted_cidrs" {
  type = list(map(string))
}
variable "my_vpc_public_subnet_cidrs" {
  type = list(map(string))
}

variable "tags" {
  type = map(string)
}

data "aws_availability_zones" "azs" {}

locals {
  azs = [data.aws_availability_zones.azs.names[0], data.aws_availability_zones.azs.names[1], data.aws_availability_zones.azs.names[2]]
}
module "my_vpc" {
  source = "../"

  azs                                               = local.azs
  create_vgw                                        = false
  enable_natgw                                      = true
  name                                              = var.my_vpc_name
  private_subnets                                   = var.my_vpc_private_subnet_cidrs

  private_subnets_vgw_route_prop_enabled            = true
  private_restricted_subnets_vgw_route_prop_enabled = true
  private_restricted_subnets                        = var.my_vpc_private_restricted_cidrs
  public_subnets                                    = var.my_vpc_public_subnet_cidrs
  public_subnets_vgw_route_prop_enabled             = false
  tags                                              = var.tags
  vgw_id                                            = ""
  vpc_cidr                                          = var.my_vpc_cidr
  enable_s3_vpc_endpoint                            = true
  enable_dynamodb_vpc_endpoint                      = true
}

output "my_vpc_public_subnets" {
  value = module.my_vpc.public_subnets
}
