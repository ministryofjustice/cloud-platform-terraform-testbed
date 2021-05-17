module "vpc" {
  version = "2.78.0"
  source  = "terraform-aws-modules/vpc/aws"

  name                   = local.vpc_name
  cidr                   = "172.20.0.0/16"
  azs                    = ["eu-west-2a"]
  private_subnets        = ["172.20.32.0/19"]
  public_subnets         = ["172.20.0.0/22"]
  enable_nat_gateway     = true
  enable_vpn_gateway     = false
  create_egress_only_igw = true
  create_igw             = true
  enable_dns_hostnames   = true
  enable_ipv6            = false

  public_subnet_tags = merge({
    SubnetType               = "Utility"
    "kubernetes.io/role/elb" = "1"
  }, local.tags)

  private_subnet_tags = merge({
    SubnetType                        = "Private"
    "kubernetes.io/role/internal-elb" = "1"
  }, local.tags)

  vpc_tags = local.tags

  tags = {
    Terraform = "true"
    Cluster   = local.vpc_name
    Domain    = local.vpc_base_domain_name
  }
}
