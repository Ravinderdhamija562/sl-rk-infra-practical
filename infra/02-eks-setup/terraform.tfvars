region          = "us-east-1"
cluster_name    = "sl-eks-cluster"
cluster_version = "1.34"

access_entries = {
  rk581_admin_user = {
    principal_arn = "arn:aws:iam::892099014844:user/rk581"
    policy_associations = {
      admin = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
}
