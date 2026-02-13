module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.26.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  enable_irsa = true

  eks_managed_node_groups = var.managed_node_groups

  cluster_addons = {
    coredns   = {}
    kube-proxy = {}
    vpc-cni   = {}
  }

  tags = var.tags
}
