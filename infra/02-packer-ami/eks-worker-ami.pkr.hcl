packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# Data source to get the latest EKS-optimized AMI
data "amazon-ami" "eks_optimized" {
  filters = {
    name                = "amazon-eks-node-al2023-x86_64-standard-${var.eks_version}-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = [var.source_ami_owner]
  region      = var.region
}

# Local variables for AMI naming and tagging
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  ami_name  = "${var.ami_name_prefix}-${var.eks_version}-${local.timestamp}"
}

source "amazon-ebs" "eks_worker" {
  ami_name      = local.ami_name
  instance_type = var.instance_type
  region        = var.region
  source_ami    = data.amazon-ami.eks_optimized.id

  ssh_username = "ec2-user"
  
  # Use temporary security group and key pair
  temporary_key_pair_type = "ed25519"
  
  tags = {
    Name          = local.ami_name
    BaseAMI       = data.amazon-ami.eks_optimized.id
    BaseAMIName   = data.amazon-ami.eks_optimized.name
    EKSVersion    = var.eks_version
    BuildDate     = local.timestamp
    NTPConfigured = "true"
    ManagedBy     = "Packer"
  }

  # Tag the snapshot as well
  snapshot_tags = {
    Name          = "${local.ami_name}-snapshot"
    EKSVersion    = var.eks_version
    BuildDate     = local.timestamp
    NTPConfigured = "true"
  }
}

build {
  name = "eks-worker-with-ntp"
  
  sources = [
    "source.amazon-ebs.eks_worker"
  ]

  # Wait for cloud-init to complete (important for EKS-optimized AMIs)
  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait",
      "echo 'Cloud-init completed successfully'"
    ]
  }

  # Run Ansible playbook to configure NTP
  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/playbook.yml"
    ansible_env_vars = [
      "ANSIBLE_CONFIG=${path.root}/ansible/ansible.cfg"
    ]
    extra_arguments = [
      "--extra-vars",
      "ansible_python_interpreter=/usr/bin/python3"
    ]
  }

  # Verify NTP is running
  provisioner "shell" {
    inline = [
      "echo 'Verifying chrony service status...'",
      "sudo systemctl status chronyd",
      "echo 'Checking chrony tracking...'",
      "sudo chronyc tracking"
    ]
  }

  # Post-processor to output AMI information
  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
