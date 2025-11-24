output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "node_group_id" {
  description = "EKS managed node group ID"
  value       = try(module.eks.eks_managed_node_groups["default"].node_group_id, "")
}

output "node_group_status" {
  description = "Status of the EKS managed node group"
  value       = try(module.eks.eks_managed_node_groups["default"].node_group_status, "")
}

output "node_group_iam_role_arn" {
  description = "IAM role ARN for the EKS managed node group"
  value       = try(module.eks.eks_managed_node_groups["default"].iam_role_arn, "")
}
