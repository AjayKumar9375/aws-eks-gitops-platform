terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  name = "devops-eks-prod"
  tags = {
    Project     = "devops-eks-platform"
    Environment = "prod"
  }
}

module "vpc" {
  source          = "../../modules/vpc"
  name            = local.name
  cidr            = "10.30.0.0/16"
  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = ["10.30.1.0/24", "10.30.2.0/24"]
  private_subnets = ["10.30.101.0/24", "10.30.102.0/24"]
  tags            = local.tags
}

module "eks" {
  source             = "../../modules/eks"
  cluster_name       = local.name
  cluster_version    = "1.29"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  managed_node_groups = {
    default = {
      desired_size   = 3
      max_size       = 8
      min_size       = 2
      instance_types = ["m5.large"]
    }
  }

  tags = local.tags
}
