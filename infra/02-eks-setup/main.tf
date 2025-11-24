module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.9.0"

  name    = var.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_public_access = true

  # Use the VPC and Subnets found via remote state
  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  enable_cluster_creator_admin_permissions = true

  access_entries = var.access_entries

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
