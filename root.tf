terraform {
  backend "s3" {}
}

#############################################
# Module: VPC #
#############################################
module "vpc" {
  source = "./modules/vpc"
  name = var.vpc_name
  cidr = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.availability_zones

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

#############################################
# Module: EKS
#############################################
module "eks" {
  source = "./modules/eks"
  region = var.region
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.vpc.private_subnets

  desired_size = var.desired_size
  max_size     = var.max_size
  min_size     = var.min_size

  node_instance_type = var.node_instance_type
  enable_autoscaler  = var.enable_autoscaler
}

#############################################
# Module: ECR
#############################################
module "ecr" {
  source = "./modules/ecr"

  repository_name                     = var.ecr_repo_name
  scan_on_push                        = var.ecr_scan_on_push
  repository_read_write_access_arns   = [module.eks.eks_cluster_role_arn, module.eks.eks_node_group_role_arn]
  repository_lifecycle_policy         = var.repository_lifecycle_policy
  tags                                = var.tags
}

