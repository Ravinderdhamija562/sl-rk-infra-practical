module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.9.0"

  name    = var.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_public_access = true
  endpoint_private_access = true
  endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
  }

  compute_config = {
   enabled = false
  }

  # Use the VPC and Subnets found via remote state
  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  enable_cluster_creator_admin_permissions = true

  # access_entries = var.access_entries

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    sl-ng = {
      ami_type                   = "CUSTOM"
      ami_id                     = var.custom_ami_id
      instance_types             = var.node_group_instance_types
      
      # enable_bootstrap_user_data = true
      user_data_template_path    = "${path.module}/al2023_user_data.tpl"
      use_latest_ami_release_version = false

      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size

      # Enable SSM Session Manager and EBS CSI Driver permissions
      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        AmazonEBSCSIDriverPolicy     = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
