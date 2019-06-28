my_vpc_name = "tfmod-aws-vpc"
# http://jodies.de/ipcalc?host=10.240.0.0&mask1=22&mask2=26
my_vpc_cidr = "10.240.0.0/22"
my_vpc_private_subnet_cidrs = [
    { name = "private", cidr = "10.240.0.0/26" },
    { name = "private", cidr = "10.240.0.64/26" },
    { name = "private", cidr = "10.240.0.128/26" }
]
my_vpc_private_restricted_cidrs = [
    { name = "private-restricted", cidr = "10.240.0.192/26" },
    { name = "private-restricted", cidr = "10.240.1.0/26" },
    { name = "private-restricted", cidr = "10.240.1.64/26" }
]
my_vpc_public_subnet_cidrs = [
    { name = "public", cidr = "10.240.1.128/26" },
    { name = "public", cidr = "10.240.1.192/26" },
    { name = "public", cidr = "10.240.2.0/26" },
]

# pinning the provider region
region = "us-west-2"


tags = {
  environment_name = "tfmod-aws-vpc"
  environment_stage = "dev"
}
