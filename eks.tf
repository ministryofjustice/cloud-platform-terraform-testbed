data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  alias                  = "testbed"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "v13.2.1"

  providers = {
    kubernetes = kubernetes.testbed
  }

  cluster_name     = local.vpc_name
  subnets          = concat(tolist(data.aws_subnet_ids.private.ids), tolist(data.aws_subnet_ids.public.ids))
  vpc_id           = data.aws_vpc.selected.id
  write_kubeconfig = false
  cluster_version  = "1.18"
  enable_irsa      = true

  node_groups = {
    default_ng = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 2
      subnets          = data.aws_subnet_ids.private.ids

      instance_type = "t3.medium"
      k8s_labels = {
        Terraform = "true"
        Cluster   = local.vpc_name
        Domain    = local.vpc_base_domain_name
      }
      additional_tags = {
        default_ng                                        = "true"
        "k8s.io/cluster-autoscaler/enabled"               = ""
        "k8s.io/cluster-autoscaler/${local.vpc_name}" = ""
      }
    }
  }

  map_users = [
    {
      userarn  = "arn:aws:iam::418216798584:user/AlejandroGarrido"
      username = "AlejandroGarrido"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::418216798584:user/PoornimaKrishnasamy"
      username = "PoornimaKrishnasamy"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::418216798584:user/paulWyborn"
      username = "paulWyborn"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::418216798584:user/SabluMiah"
      username = "SabluMiah"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::418216798584:user/jasonBirchall"
      username = "jasonBirchall"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::418216798584:user/RazvanCosma"
      username = "RazvanCosma"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::418216798584:user/VijayVeeranki"
      username = "VijayVeeranki"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::418216798584:user/terratest"
      username = "terratest"
      groups   = ["system:masters"]
    }
  ]

  tags = {
    Terraform = "true"
    Cluster   = local.vpc_name
    Domain    = local.vpc_base_domain_name
  }

}
