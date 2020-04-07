locals {
  nat_gateway_count = var.enable_natgw ? length(var.private_subnets) : 0
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { "Name" = format("%s", var.name) })
}

resource "aws_vpc_dhcp_options" "dhcp_opts" {
  count       = length(var.dhcp_options_domain_name) > 0 ? 1 : 0
  domain_name = var.dhcp_options_domain_name
  tags        = merge(var.tags, { "Name" = format("%s", var.name) })
}

resource "aws_vpc_dhcp_options_association" "dhcp_opts" {
  count           = length(var.dhcp_options_domain_name) > 0 ? 1 : 0
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_opts[0].id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, { "Name" = format("%s", var.name) })
}

resource "aws_eip" "natgw_eip" {
  count = local.nat_gateway_count
  vpc   = true
  tags  = merge(var.tags, { "Name" = format("%s-natgw-%s", var.name, substr(element(var.azs, count.index), -1, 1)) })
}

resource "aws_nat_gateway" "natgw" {
  count         = local.nat_gateway_count
  allocation_id = element(aws_eip.natgw_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  tags          = merge(var.tags, { "Name" = format("%s-%s", var.name, substr(element(var.azs, count.index), -1, 1)) })
}


resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = lookup(var.public_subnets[count.index], "cidr")
  tags = merge(var.tags, {
    "Name"             = format("%s-%s-%s", var.name, lookup(var.public_subnets[count.index], "name"), substr(element(var.azs, count.index), -1, 1))
    "ews:network-type" = lookup(var.public_subnets[count.index], "name")
  })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = lookup(var.private_subnets[count.index], "cidr")
  tags = merge(var.tags, {
    "Name"             = format("%s-%s-%s", var.name, lookup(var.private_subnets[count.index], "name"), substr(element(var.azs, count.index), -1, 1))
    "ews:network-type" = lookup(var.private_subnets[count.index], "name")
  })
}

resource "aws_subnet" "private_restricted" {
  count = length(var.private_restricted_subnets)

  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = lookup(var.private_restricted_subnets[count.index], "cidr")
  tags = merge(var.tags, {
    "Name"             = format("%s-%s-%s", var.name, lookup(var.private_restricted_subnets[count.index], "name"), substr(element(var.azs, count.index), -1, 1))
    "ews:network-type" = lookup(var.private_restricted_subnets[count.index], "name")
  })
}

# create a single route table for all public subnets
resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, { "Name" = format("%s-public", var.name) })
}

# conditionally create this route
resource "aws_route" "public_rt_igw" {
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

# create a route table for each private subnet
resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, { "Name" = format("%s-%s-%s", var.name, lookup(var.private_subnets[count.index], "name"), substr(element(var.azs, count.index), -1, 1)) })
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "private_natgw" {
  count = var.enable_natgw ? length(var.private_subnets) : 0

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.natgw.*.id, count.index)
}


resource "aws_route_table" "private_restricted" {
  count = length(var.private_restricted_subnets)

  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, { "Name" = format("%s-%s-%s", var.name, lookup(var.private_restricted_subnets[count.index], "name"), substr(element(var.azs, count.index), -1, 1)) })
}


resource "aws_route_table_association" "private_restricted" {
  count = length(var.private_restricted_subnets)

  subnet_id      = element(aws_subnet.private_restricted.*.id, count.index)
  route_table_id = element(aws_route_table.private_restricted.*.id, count.index)
}

# conditionally create a vgw or attach an already existing vgw
resource "aws_vpn_gateway" "vgw" {
  count = var.create_vgw ? 1 : 0

  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, { "Name" = format("%s", var.name) })
}

resource "aws_vpn_gateway_attachment" "vgw" {
  count = var.vgw_id != "" ? 1 : 0

  vpc_id         = aws_vpc.vpc.id
  vpn_gateway_id = var.vgw_id
}

# conditionally enable route propagation on route tables
resource "aws_vpn_gateway_route_propagation" "public" {
  count = var.public_subnets_vgw_route_prop_enabled && (var.create_vgw || var.vgw_id != "") ? 1 : 0

  route_table_id = element(aws_route_table.public.*.id, count.index)
  vpn_gateway_id = element(concat(aws_vpn_gateway.vgw.*.id, aws_vpn_gateway_attachment.vgw.*.vpn_gateway_id), count.index)
}

resource "aws_vpn_gateway_route_propagation" "private" {
  count = var.private_subnets_vgw_route_prop_enabled && (var.create_vgw || var.vgw_id != "") ? length(var.private_subnets) : 0

  route_table_id = element(aws_route_table.private.*.id, count.index)
  vpn_gateway_id = element(concat(aws_vpn_gateway.vgw.*.id, aws_vpn_gateway_attachment.vgw.*.vpn_gateway_id), count.index)
}

resource "aws_vpn_gateway_route_propagation" "private_restricted" {
  count = var.private_restricted_subnets_vgw_route_prop_enabled && (var.create_vgw || var.vgw_id != "") ? length(var.private_restricted_subnets) : 0

  route_table_id = element(aws_route_table.private_restricted.*.id, count.index)
  vpn_gateway_id = element(concat(aws_vpn_gateway.vgw.*.id, aws_vpn_gateway_attachment.vgw.*.vpn_gateway_id), count.index)
}

#### vpc gateway endpoints

#### s3 vpc endpoint
data "aws_vpc_endpoint_service" "s3" {
  count = var.enable_s3_vpc_endpoint ? 1 : 0

  service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_vpc_endpoint ? 1 : 0

  vpc_id       = aws_vpc.vpc.id
  service_name = data.aws_vpc_endpoint_service.s3[0].service_name
  tags         = merge(var.tags, { "Name" = format("%s-s3", var.name) })
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count = var.enable_s3_vpc_endpoint && length(var.public_subnets) > 0 ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.public.*.id, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = var.enable_s3_vpc_endpoint ? length(var.private_subnets) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "private_restricted_s3" {
  count = var.enable_s3_vpc_endpoint ? length(var.private_restricted_subnets) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.private_restricted.*.id, count.index)
}


#### dynamodb vpc endpoint
data "aws_vpc_endpoint_service" "dynamodb" {
  count = var.enable_dynamodb_vpc_endpoint ? 1 : 0

  service = "dynamodb"
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_vpc_endpoint ? 1 : 0

  vpc_id       = aws_vpc.vpc.id
  service_name = data.aws_vpc_endpoint_service.dynamodb[0].service_name
  tags         = merge(var.tags, { "Name" = format("%s-dynamodb", var.name) })
}

resource "aws_vpc_endpoint_route_table_association" "public_dynamodb" {
  count = var.enable_dynamodb_vpc_endpoint && length(var.public_subnets) > 0 ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.public.*.id, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "private_dynamodb" {
  count = var.enable_dynamodb_vpc_endpoint ? length(var.private_subnets) : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "private_restricted_dynamodb" {
  count = var.enable_dynamodb_vpc_endpoint ? length(var.private_restricted_subnets) : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.private_restricted.*.id, count.index)
}

#### other config
resource "aws_default_security_group" "default" {
  count = var.delete_default_sg_rules ? 1 : 0

  vpc_id = aws_vpc.vpc.id
  tags = merge({
    "Name"     = "Default"
    "comments" = "Do not use"
    },
  var.tags)
}
