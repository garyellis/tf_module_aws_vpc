output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnets" {
  value = concat(aws_subnet.public[*])
}

output "private_subnets" {
  value = concat(aws_subnet.private[*])
}

output "private_restricted_subnets" {
  value = concat(aws_subnet.private_restricted[*])
}
