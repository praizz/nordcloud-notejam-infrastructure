data "aws_eks_cluster" "notejam_cluster" {
  name = module.notejam_eks.cluster_id
}

data "aws_eks_cluster_auth" "notejam_cluster" {
  name = module.notejam_eks.cluster_id
}