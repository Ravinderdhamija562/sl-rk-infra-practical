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

## 00-remote-state

It should be running once and the created s3 bucket should be used in the remote state of other terraform managed resources.

```bash
cd 00-remote-state
terraform init
terraform plan
terraform apply
```

## 01-aws-setup

```bash
cd 01-aws-setup
terraform init
terraform plan
terraform apply
```

## 02-eks-setup

```bash
cd 02-eks-setup
terraform init
terraform plan
terraform apply
```
