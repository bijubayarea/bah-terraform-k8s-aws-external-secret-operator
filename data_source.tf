
# use local s3 backend tfstate
# local backed tfstate
data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "../bah-terraform-eks-cluster/terraform.tfstate"
  }
}

# EKS cluster data
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

# Get the OIDC provider provisioned for EKS cluster
data "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

