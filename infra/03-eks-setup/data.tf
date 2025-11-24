data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "sl-rk-infra-terraform-state-gx0o7pq9"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}


