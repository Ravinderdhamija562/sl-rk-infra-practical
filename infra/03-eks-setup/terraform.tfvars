region          = "us-east-1"
cluster_name    = "sl-eks-cluster"
cluster_version = "1.34"

# access_entries = {
#   rk581_admin_user = {
#     principal_arn = "arn:aws:iam::892099014844:user/rk581"
#     policy_associations = {
#       admin = {
#         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#         access_scope = {
#           type = "cluster"
#         }
#       }
#     }
#   }
# }

# Node Group Configuration
custom_ami_id              = "ami-0771b938b7aeaabd2" # ami created from 02-packer-ami folder with ntp configured from ansible playbook
node_group_instance_types  = ["t3.small"]
node_group_min_size        = 1
node_group_max_size        = 4
node_group_desired_size    = 3
