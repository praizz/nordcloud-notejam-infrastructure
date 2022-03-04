variable "cluster_name" {
  type        = string
  description = "the EKS cluster name"
  default     = "notejam-eks"
}

variable "aws_region" {
  type        = string
  description = "the AWS region to create all the resources"
  default     = "eu-west-1"
}

variable "public-subnets" {
  description = "the public subnets to provision on the vpc"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}