# tf_module_aws_vpc
This terraform module creates the following resources:

* vpc
* dhcp option set (optional)
* nat gateways (optional - one natgw for each private subnet)
* nat gateway eips (optional)
* nat gateway existing EIP associations (optional)
* public subnets (optional)
* a public route table when applicable
* private subnets (optional)
* private subnet route tables when applicable
* private "restricted" subnets (optional - subnets with no internet access) 
* private restricted subnet route tables when applicable
* vgw (optional)
* vgw association to an existing vgw  (optional)


## Usage
todo
