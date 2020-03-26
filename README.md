# tf_module_aws_vpc
This terraform module creates the following resources:

* vpc
* dhcp option set (optional)
* nat gateways (optional - one natgw for each private subnet)
* nat gateway eips (optional)
* nat gateway existing EIP associations (optional)
* public subnets (optional)
* public route table when applicable
* private subnets (optional)
* private subnet route tables when applicable
* private "restricted" subnets (optional) (subnets with no internet access) 
* private restricted subnet route tables when applicable
* vgw and association to vpc (optional)
* vpc association to an existing vgw  (optional)

## Terraform version

* v0.12

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| azs | A list of availability zone names. | `list(string)` | n/a | yes |
| create\_vgw | Create a vgw associated to the vpc? | `bool` | `false` | no |
| delete\_default\_sg\_rules | wipe the default security group rules. | `bool` | `true` | no |
| dhcp\_options\_domain\_name | Set a dhcp option set domain name. This value should be an empty string when not used. | `string` | `""` | no |
| enable\_dynamodb\_vpc\_endpoint | Enable dynamodb vpc endpoint. | `bool` | `false` | no |
| enable\_natgw | Create nat gateways. Valid values are 0 and 1. | `bool` | `false` | no |
| enable\_s3\_vpc\_endpoint | Enable s3 vpc endpoint. | `bool` | `false` | no |
| name | the vpc name | `string` | n/a | yes |
| private\_restricted\_subnets | A list of subnet maps. Private restricted subnets do not have routes to to an igw or nat | `list(map(string))` | `[]` | no |
| private\_restricted\_subnets\_vgw\_route\_prop\_enabled | Enable route propagation on private restricted subnets. | `bool` | `false` | no |
| private\_subnets | A list of subnet maps. Private subnet route tables have a rounte to a nat gateway. | `list(map(string))` | `[]` | no |
| private\_subnets\_vgw\_route\_prop\_enabled | Enable route propagation on private subnets. | `bool` | `false` | no |
| public\_subnets | A list of subnet maps. Public subnets have a route to the route vpc igw. | `list(map(string))` | `[]` | no |
| public\_subnets\_vgw\_route\_prop\_enabled | Enable route propagation on public subnets. | `bool` | `false` | no |
| tags | A map of tags to create on all taggable resources. | `map(string)` | `{}` | no |
| vgw\_id | Associate the vpc to an existing vgw. | `string` | `""` | no |
| vpc\_cidr | The vpc CIDR block. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dynamodb\_vpc\_endpoint\_id | n/a |
| dynamodb\_vpc\_endpoint\_prefix\_list\_id | n/a |
| private\_restricted\_subnet\_ids | n/a |
| private\_restricted\_subnets | n/a |
| private\_subnet\_ids | n/a |
| private\_subnets | n/a |
| public\_subnet\_ids | n/a |
| public\_subnets | n/a |
| s3\_vpc\_endpoint\_id | n/a |
| s3\_vpc\_endpoint\_prefix\_list\_id | n/a |
| vgw\_id | n/a |
| vpc\_cidr | n/a |
| vpc\_id | n/a |

## Usage
