# Custom EKS Worker Node AMI with NTP

This directory contains Packer and Ansible configurations to build a custom AMI for EKS worker nodes with NTP (chrony) pre-configured.

## Overview

The custom AMI is based on the official AWS EKS-optimized Amazon Linux 2 AMI and includes:

- **Chrony NTP service** installed and configured
- **AWS Time Sync Service** as the primary time source (169.254.169.123)
- **Amazon NTP pool** as fallback time servers
- Automatic service startup on boot

## Prerequisites

Before building the AMI, ensure you have:

1. **Packer** installed

   ```bash
   brew install packer
   ```

2. **Ansible** installed

   ```bash
   brew install ansible
   ```

3. **AWS credentials**

   ```bash
   export AWS_ACCESS_KEY_ID=your_access_key
   export AWS_SECRET_ACCESS_KEY=your_secret_key
   export AWS_DEFAULT_REGION=us-east-1
   ```

## Building the AMI

```bash
cd sl-rk-infra-practical/infra/03-packer-ami
packer init .
packer validate .
packer build .
```
