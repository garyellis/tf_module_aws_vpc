data "aws_availability_zones" "azs" {}

module "my_vpc" {
  source = "../"

  azs                                    = ["${data.aws_availability_zones.azs.names[0]}", "${data.aws_availability_zones.azs.names[1]}", "${data.aws_availability_zones.azs.names[2]}"]
  create_vgw                             = "0"
  enable_natgw                           = "1"
  name                                   = "${var.my_vpc_name}"
  private_subnets                        = ["${var.my_vpc_private_subnet_cidrs}"]

  private_subnets_vgw_route_prop_enabled = "0"
  private_restricted_subnets_vgw_route_prop_enabled = "0"
  private_restricted_subnets             = ["${var.my_vpc_private_restricted_cidrs}"]
  public_subnets = ["${var.my_vpc_public_subnet_cidrs}"]
  public_subnets_vgw_route_prop_enabled  = "0"
  tags                                   = "${var.tags}"
  vgw_id                                 = ""
  vpc_cidr                               = "${var.my_vpc_cidr}"
}
