variable "azs" {
  description = "A list of availability zone names."
  type = "list"
}

variable "dhcp_options_domain_name" {
  description = "Set a dhcp option set domain name. This value should be an empty string when not used."
  type        = "string"
  default     = ""
}

variable "create_vgw" {
  description = "Create a vgw associated to the vpc. Valid values are 0 and 1"
  type        = "string"
  default     = "0"
}

variable "enable_natgw" {
  description = "Create nat gateways. Valid values are 0 and 1."
  type        = "string"
  default     = "0"
}

variable "name" {
  description = "the vpc name"
  type        = "string"
}

variable "public_subnets" {
    description = "A list of subnet maps. Public subnets route table has a route to the vpc igw."
    type = "list"
    default = []
}

variable "public_subnets_vgw_route_prop_enabled" {
  description = "Enable route propagation on public subnets. Valid values are 0 and 1."
  type        = "string"
  default      = "0"
}

variable "private_subnets" {
  description = "A list of subnet maps. Private subnet route tables have a round to natgw when applicable."
  type        = "list"
  default     = []
}

variable "private_subnets_vgw_route_prop_enabled" {
  description = "Enable route propagation on private subnets. Valid values are 0 and 1."
  type        = "string"
  default     = "0"
}

variable "private_restricted_subnets" {
  description = "A list of subnet maps. Private restricted subnets do not have access to natgw."
  type        = "list"
  default     = []
}

variable "private_restricted_subnets_vgw_route_prop_enabled" {
  description = "Enable route propagation on private restricted subnets. Valid values are 0 and 1."
  type        = "string"
  default     = "0"
}

variable "vpc_cidr" {
  description = "The vpc cidr block."
  type        = "string"
}

variable "tags" {
  description = "Apply a map of tags to all taggable resources." 
  type        = "map"
}

variable "vgw_id" {
  description = "Associate an existing vgw to the vpc. The value should be a vgw id or an empty string."
  type        = "string"
  default     = ""
}
