# How to use it

## Prerequisites

1. terraform installed with version > v1.10.0

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

2. aws cli installed

```bash
brew install awscli
```

## Directory Structure

- `00-remote-state/` - S3 backend for Terraform state management
- `01-aws-setup/` - VPC, networking, and ECR repository setup
- `02-eks-setup/` - EKS cluster and managed node group configuration
- `03-packer-ami/` - Custom AMI building with Packer and Ansible for NTP configuration

## Deployment Order

### 1. Remote State Setup

```bash
cd 00-remote-state
terraform init
terraform apply
```

### 2. AWS Infrastructure Setup

```bash
cd ../01-aws-setup
terraform init
terraform apply
```

### 3. (Optional) Build Custom AMI

Build a custom EKS worker node AMI with NTP pre-configured:

```bash
cd ../03-packer-ami
packer init .
packer validate .
packer build .
```

After the build completes, note the AMI ID from the output and update `02-eks-setup/terraform.tfvars`:

```hcl
custom_ami_id = "ami-xxxxxxxxxxxxxxxxx"  # Replace with your AMI ID
```

See [03-packer-ami/README.md](03-packer-ami/README.md) for detailed instructions.

### 4. EKS Cluster Setup

```bash
cd ../02-eks-setup
terraform init
terraform apply
```

## Custom AMI with NTP

The `03-packer-ami` directory contains configurations to build a custom EKS worker node AMI with:

- **Chrony NTP service** installed and configured
- **AWS Time Sync Service** as the primary time source
- **Amazon NTP pool** as fallback servers

This is optional but recommended for production deployments to ensure time synchronization across all worker nodes.

## Accessing the EKS Cluster

After deployment, configure kubectl:

```bash
aws eks update-kubeconfig --region us-east-1 --name sl-eks-cluster
kubectl get nodes
```

## Accessing Worker Nodes via SSM

Ensure you have the [Session Manager plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) installed.

1. Get the instance ID of a worker node:

   ```bash
   kubectl get nodes -o wide
   # Note the internal IP, then find the instance ID via AWS CLI
   aws ec2 describe-instances --filters "Name=private-ip-address,Values=<NODE_PRIVATE_IP>" --query "Reservations[*].Instances[*].InstanceId" --output text
   ```

2. Start the session:

   ```bash
   aws ssm start-session --target <INSTANCE_ID>
   ```
