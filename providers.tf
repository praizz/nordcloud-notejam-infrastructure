provider "aws" {
  region = "eu-west-1"
  profile = "nordcloud"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.notejam_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.notejam_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.notejam_cluster.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.notejam_cluster.endpoint
    token                  = data.aws_eks_cluster_auth.notejam_cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.notejam_cluster.certificate_authority.0.data)
  }
}
