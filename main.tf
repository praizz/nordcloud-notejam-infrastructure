locals {
  name = "notejam"
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "notejam_vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = "notejam-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets  = var.public-subnets

  enable_nat_gateway = false #read
  enable_vpn_gateway = false

  tags = local.tags
}

module "notejam_eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"
  subnet_ids      = module.notejam_vpc.public_subnets
  vpc_id          = module.notejam_vpc.vpc_id


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 20
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }
  tags = local.tags
}

# run 'aws eks update-kubeconfig ...' locally and update local kube config
resource "null_resource" "update_kubeconfig" {
  depends_on = [module.notejam_eks]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.aws_region}"
  }
}

module "ecr" {
  source = "cloudposse/ecr/aws"
  name   = "notejam-ecr"
  tags   = local.tags
}