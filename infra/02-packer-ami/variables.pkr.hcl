variable "region" {
  type    = string
  default = "us-east-1"
  description = "AWS region where the AMI will be built and stored"
}

variable "eks_version" {
  type    = string
  default = "1.34"
  description = "EKS version for the worker nodes"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
  description = "Instance type to use for building the AMI"
}

variable "ami_name_prefix" {
  type    = string
  default = "eks-worker-ntp"
  description = "Prefix for the AMI name"
}

variable "source_ami_owner" {
  type    = string
  default = "602401143452"
  description = "AWS account ID that owns the EKS-optimized AMIs (Amazon)"
}
