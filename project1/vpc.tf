//VPC as a module (below this line)
module "vpc" {
source = "terraform-aws-modules/vpc/aws"
name = "main"
cidr = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24"]
azs =  ["eu-west-2a"]
enable_dns_support = true
enable_dns_hostnames = true

private_subnets      = []
enable_nat_gateway   = false
enable_vpn_gateway   = false
}