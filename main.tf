provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias   = "ephemeral"
  profile = "ephemeral"
  region  = "eu-west-2"
}

locals {
  vpc_name             = "testbed"
  vpc_base_domain_name = "${local.vpc_name}.cloud-platform.service.justice.gov.uk"
  tags = {
    "kubernetes.io/cluster/${local.vpc_name}" = "shared"
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    SubnetType = "Private"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    SubnetType = "Utility"
  }
}
