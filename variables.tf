variable "azs" {
  description = "A list of availability zone names."
  type        = list(string)
}

variable "dhcp_options_domain_name" {
  description = "Set a dhcp option set domain name. This value should be an empty string when not used."
  type        = string
  default     = ""
}

variable "create_vgw" {
  description = "Create a vgw associated to the vpc?"
  type        = bool
  default     = false
}

variable "enable_natgw" {
  description = "Create nat gateways. Valid values are 0 and 1."
  type        = bool
  default     = false
}

variable "name" {
  description = "the vpc name"
  type        = string
}

variable "public_subnets" {
  description = "A list of subnet maps. Public subnets have a route to the route vpc igw."
  type        = list(map(string))
  default     = []
}

variable "public_subnets_vgw_route_prop_enabled" {
  description = "Enable route propagation on public subnets."
  type        = bool
  default     = false
}

variable "private_subnets" {
  description = "A list of subnet maps. Private subnet route tables have a rounte to a nat gateway."
  type        = list(map(string))
  default     = []
}

variable "private_subnets_vgw_route_prop_enabled" {
  description = "Enable route propagation on private subnets."
  type        = bool
  default     = false
}

variable "private_restricted_subnets" {
  description = "A list of subnet maps. Private restricted subnets do not have routes to to an igw or nat"
  type        = list(map(string))
  default     = []
}

variable "private_restricted_subnets_vgw_route_prop_enabled" {
  description = "Enable route propagation on private restricted subnets."
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "The vpc CIDR block."
  type        = string
}

variable "tags" {
  description = "A map of tags to create on all taggable resources."
  type        = map(string)
  default     = {}
}

variable "vgw_id" {
  description = "Associate the vpc to an existing vgw."
  type        = string
  default     = ""
}


#### vpc gateway endpoints
variable "enable_s3_vpc_endpoint" {
  description = "Enable s3 vpc endpoint."
  type        = bool
  default     = false
}

variable "enable_dynamodb_vpc_endpoint" {
  description = "Enable dynamodb vpc endpoint."
  type        = bool
  default     = false
}

#### other
variable "delete_default_sg_rules" {
  description = "wipe the default security group rules."
  type        = bool
  default     = true
}
