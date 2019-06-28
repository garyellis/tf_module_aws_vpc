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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azs | A list of availability zone names. | `list(string)` | n/a | yes |
| create\_vgw | Create a vgw associated to the vpc | `bool` | `false` | no |
| dhcp\_options\_domain\_name | Set a dhcp option set domain name. This value should be an empty string when not used. | `string` | `""` | no |
| enable\_natgw | Create nat gateways. | `bool` | `false` | no |
| name | the vpc name | `string` | n/a | yes |
| private\_restricted\_subnets | A list of subnet maps. Private restricted subnets do not have access to a natgw. | `list(map(string))` | `[]` | no |
| private\_restricted\_subnets\_vgw\_route\_prop\_enabled | Enable route propagation on private restricted subnets. Valid values are 0 and 1. | `bool` | `false` | no |
| private\_subnets | A list of subnet maps. Private subnet route tables have a route to the natgw when natgw is enabled. | `list(map(string))` | `[]` | no |
| private\_subnets\_vgw\_route\_prop\_enabled | Enable route propagation on private subnets. | `bool` | `false` | no |
| public\_subnets | A list of subnet maps. Public subnets route table has a route to the vpc igw. | `list(map(string))` | `[]` | no |
| public\_subnets\_vgw\_route\_prop\_enabled | Enable route propagation on public subnets. | `bool` | `` | no |
| tags | Apply a map of tags to all taggable resources. | `map(string)` | `{}` | no |
| vgw\_id | Associate an existing vgw to the vpc. The value should be a vgw id or an empty string. | `string` | `""` | no |
| vpc\_cidr | The vpc cidr block. | `string` | n/a | yes |

## Outputs

| Name | Description | Type |
|------|-------------|:-----:
| vpc\_cidr |  | `string`|
| vpc\_id |  | `string` |

## Usage
