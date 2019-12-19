output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  value = [
    for i in compact(aws_subnet.public.*.id):
      i
  ]
}

output "public_subnets" {
  value = concat(aws_subnet.public[*])
}

output "private_subnet_ids" {
  value = [
    for i in compact(aws_subnet.private.*.id):
      i
  ]
}

output "private_subnets" {
  value = concat(aws_subnet.private[*])
}

output "private_restricted_subnet_ids" {
  value = [
    for i in compact(aws_subnet.private_restricted.*.id):
      i
  ]
}

output "private_restricted_subnets" {
  value = concat(aws_subnet.private_restricted[*])
}

output "s3_vpc_endpoint_id" {
  value = concat(aws_vpc_endpoint.s3.*.id)
}

output "dynamodb_vpc_endpoint_id" {
  value = concat(aws_vpc_endpoint.dynamodb.*.id)
}
