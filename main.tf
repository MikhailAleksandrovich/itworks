provider "aws" {
  region = "il-central-1"  # Ваш регион
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  name    = "eks-vpc"
  cidr    = "10.0.0.0/16"
  azs     = ["il-central-1a", "il-central-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-cluster"
  cluster_version = "1.24"
  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 2

      instance_type = "t3.micro"
    }
  }
}